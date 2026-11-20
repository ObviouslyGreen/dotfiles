#!/usr/bin/env bash
# macOS notification for Claude Code's Notification hook.
# Fires when Claude is waiting for input or permission/approval.
# Reads the hook's JSON payload from stdin and shows a native banner.
# Clicking the banner focuses the Rex or WezTerm pane Claude is running in.

WEZTERM_BUNDLE_ID="com.github.wez.wezterm"
REX_BUNDLE_ID="com.superlogical.rex"

payload=$(cat)

# The hook payload carries the notification text, working dir, session id, the
# transcript path, and notification_type ("permission_prompt" vs idle/waiting).
message=$(printf '%s' "$payload" | jq -r '.message // "Claude is waiting for input"')
cwd=$(printf '%s' "$payload" | jq -r '.cwd // ""')
session=$(printf '%s' "$payload" | jq -r '.session_id // "claude-code"')
transcript=$(printf '%s' "$payload" | jq -r '.transcript_path // ""')
ntype=$(printf '%s' "$payload" | jq -r '.notification_type // ""')

# Use the project folder name as the subtitle so multiple sessions are distinguishable.
subtitle="Claude Code"
[ -n "$cwd" ] && subtitle=$(basename "$cwd")

# Claude's own notification text is generic ("Claude needs your permission").
# Pull the specific detail from the transcript's last assistant turn, choosing
# what to show based on notification_type:
#   - permission_prompt: the pending tool name + command/file
#   - otherwise (idle/waiting): just the trailing question, not the whole message
# Each branch falls back to the other, and to the generic message, if empty.
body="$message"
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  detail=$(tail -n 200 "$transcript" 2>/dev/null | jq -rs --arg ntype "$ntype" '
    # tool name + command/file, whitespace-collapsed
    def tooldetail($t):
      ($t.name + (
        if ($t.input.command // empty) != "" then ": " + $t.input.command
        elif ($t.input.file_path // empty) != "" then ": " + $t.input.file_path
        else "" end) | gsub("\\s+";" "));
    # the trailing non-blank line of the message — usually the actual ask
    def question($x):
      ($x | split("\n")
          | map(select(test("[^[:space:]]")))            # keep non-blank lines
          | (last // "")                                  # take the last one
          | gsub("^[[:space:]]*[-*+][[:space:]]+";"")     # strip a leading bullet
          | gsub("[*`]";"")                               # strip bold/code markers
          | gsub("^[[:space:]]+|[[:space:]]+$";""));      # trim

    ([ .[] | select(.type=="assistant") ] | last) as $last
    | ($last.message.content // []) as $c
    | ($c | map(select(.type=="tool_use")) | last) as $tool
    | ($c | map(select(.type=="text") | .text) | last) as $txt
    | (if $ntype == "permission_prompt" then
         (if $tool then tooldetail($tool) elif ($txt // "") != "" then question($txt) else empty end)
       else
         (if ($txt // "") != "" then question($txt) elif $tool then tooldetail($tool) else empty end)
       end)
    | .[0:160]
  ' 2>/dev/null)
  [ -n "$detail" ] && body="$detail"
fi

notifier=$(command -v terminal-notifier)
if [ -n "$notifier" ]; then
  # Decide the click action. If this session lives in a Rex or WezTerm pane, jump
  # straight to that pane/tab/window; otherwise just bring the app forward.
  # The pane id is captured now (at notify time) and baked into the click command.
  wezterm_bin=$(command -v wezterm)
  click_args=(-activate "$WEZTERM_BUNDLE_ID")
  sound_args=(-sound Pop)
  focus_helper="$HOME/bin/claude-focus-pane.sh"
  if [ -n "$REX_BLOCK" ] && [ -x "$REX_BIN_DIR/rex" ]; then
    # Rex already plays its own sound when Claude stops, so stay silent here.
    sound_args=()
    click_args=(-activate "$REX_BUNDLE_ID"
      -execute "'$REX_BIN_DIR/rex' focus -s $REX_SESSION $REX_BLOCK")
  elif [ -n "$wezterm_bin" ] && [ -n "$WEZTERM_PANE" ] && [ -x "$focus_helper" ]; then
    # Delegate the click action to a dedicated helper (passing this pane's id and
    # socket) — keeps complex shell out of terminal-notifier's -execute parser,
    # which silently drops multi-statement commands.
    click_args=(-execute "$focus_helper ${WEZTERM_PANE} ${WEZTERM_UNIX_SOCKET}")
  fi

  # -group replaces this session's previous banner instead of stacking them up.
  "$notifier" \
    -title "Claude Code" \
    -subtitle "$subtitle" \
    -message "$body" \
    -group "claude-code-$session" \
    "${sound_args[@]}" \
    "${click_args[@]}" >/dev/null 2>&1 || true
  exit 0
fi

# Fallback: osascript (no click-to-focus, attributed to Script Editor).
# Pass strings as argv (not interpolated) to avoid AppleScript injection.
osascript \
  -e 'on run {msg, sub}' \
  -e 'display notification msg with title "Claude Code" subtitle sub sound name "Pop"' \
  -e 'end run' \
  "$body" "$subtitle" 2>/dev/null || true
