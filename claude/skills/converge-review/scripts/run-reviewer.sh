#!/usr/bin/env bash
# Runs one read-only review turn inside a rex pane and renders the result.
# Usage: [REVIEW_READ_DIRS=dir1:dir2] run-reviewer.sh <codex|claude> <round> <title> <prompt-file> <out-file> [model]
# REVIEW_READ_DIRS: extra directories the Claude reviewer may read (Codex's read-only sandbox reads anywhere).
set -uo pipefail

if [[ $# -lt 5 ]]; then
  echo "usage: run-reviewer.sh <codex|claude> <round> <title> <prompt-file> <out-file> [model]" >&2
  exit 2
fi

reviewer=$1 round=$2 title=$3 prompt=$4 out=$5 model=${6:-}
CLEAN_SENTINEL="NO MATERIAL FINDINGS"
DEFAULT_CODEX_MODEL="gpt-6.1-sol"
DEFAULT_CLAUDE_MODEL="opus"
CODEX_REVIEW_EFFORT="high"
FALLBACK_COLS=80
RESET=$'\e[0m' BOLD=$'\e[1m' DIM=$'\e[2m' RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m'

case $reviewer in
  codex) accent=$'\e[38;5;42m' model=${model:-$DEFAULT_CODEX_MODEL} ;;
  claude) accent=$'\e[38;5;209m' model=${model:-$DEFAULT_CLAUDE_MODEL} ;;
  *) echo "unknown reviewer: $reviewer" >&2; exit 2 ;;
esac

pane_cols() { local size; size=$(stty size </dev/tty 2>/dev/null) && echo "${size#* }" && return; echo "$FALLBACK_COLS"; }

rule() { printf '%s%s%s\n' "$accent" "$(printf '━%.0s' $(seq 1 "$(pane_cols)"))" "$RESET"; }

render() {
  # Keep link text, drop targets: [predict.py:208](/abs/path) -> predict.py:208
  local clean; clean=$(perl -pe 's/\[([^\]]+)\]\([^)]*\)/$1/g' "$1")
  if command -v glow >/dev/null; then glow -s dark -w "$(( $(pane_cols) - 2 ))" - <<<"$clean"; return; fi
  printf '%s\n' "$clean"
}

# Activity feed: one dim line per reviewer event, truncated to the pane width.
FEED_PRELUDE='def line: tostring | split("\n") | map(select(test("\\S"))) | (.[0] // "") ;
  def fit: if length > $w then .[0:$w-1] + "…" else . end ;
  def show: select(length > 2) | "\u001b[2m  " + fit + "\u001b[0m" ;'

CODEX_FEED=$FEED_PRELUDE'
  select(.type == "item.started" or .type == "item.completed") | .type as $t | .item |
  if $t == "item.started" and .type == "command_execution" then
    "$ " + (.command | sub("^/bin/(zsh|bash) -lc "; "") | ([39] | implode) as $q | ltrimstr($q) | rtrimstr($q) | line)
  elif $t == "item.started" and .type == "web_search" then "⌕ " + (.query // "web search" | line)
  elif $t == "item.completed" and (.type == "reasoning" or .type == "agent_message") then "· " + (.text | line)
  else empty end | show'

CLAUDE_FEED=$FEED_PRELUDE'
  select(.type == "assistant") | .message.content[] |
  if .type == "tool_use" then
    "→ " + .name + " " + ((.input.file_path | values | split("/") | last)
      // .input.pattern // .input.command // .input.path // "" | line)
  elif .type == "thinking" then "· " + (.thinking | line)
  elif .type == "text" then "· " + (.text | line)
  else empty end | show'

run_codex() {
  codex exec --json --sandbox read-only --skip-git-repo-check --ephemeral \
    -m "$model" -c model_reasoning_effort="$CODEX_REVIEW_EFFORT" -o "$out" - < "$prompt" 2> "$out.err" |
    tee "$out.log" | jq --unbuffered -r --argjson w "$FEED_WIDTH" "$CODEX_FEED" 2>/dev/null
  return "${PIPESTATUS[0]}"
}

run_claude() {
  local add_dirs=() dir
  IFS=: read -ra dirs <<<"${REVIEW_READ_DIRS:-}"
  for dir in ${dirs[@]+"${dirs[@]}"}; do [[ -n $dir ]] && add_dirs+=(--add-dir "$dir"); done

  # dontAsk denies every tool call not allowed below, so the reviewer can read but never edit.
  claude -p --model "$model" --no-session-persistence --output-format stream-json --verbose \
    ${add_dirs[@]+"${add_dirs[@]}"} --tools Read,Grep,Glob,Bash \
    --allowedTools 'Bash(git diff:*)' 'Bash(git log:*)' 'Bash(git show:*)' 'Bash(git status:*)' 'Bash(gh pr diff:*)' 'Bash(gh pr view:*)' \
    --permission-mode dontAsk < "$prompt" 2> "$out.err" |
    tee "$out.log" | jq --unbuffered -r --argjson w "$FEED_WIDTH" "$CLAUDE_FEED" 2>/dev/null
  local status=${PIPESTATUS[0]}
  jq -r 'select(.type == "result" and .subtype == "success") | .result' "$out.log" > "$out"
  # Reads blocked for being outside the allowed dirs; the main session widens the dirs and reruns.
  jq -r 'select(.type == "result") | .permission_denials[]?
    | select(.tool_name == "Read" or .tool_name == "Grep" or .tool_name == "Glob")
    | .tool_input.file_path // .tool_input.path // empty' "$out.log" | sort -u > "$out.denied"
  return "$status"
}

# Reviewers must not drive this rex session (its startup context invites a session rename).
for var in ${!REX_@}; do unset "$var"; done
FEED_WIDTH=$(( $(pane_cols) - 4 ))

rule
printf '%s%s  Round %s · %s%s  %s(%s)%s\n' "$BOLD" "$accent" "$round" "$reviewer" "$RESET" "$DIM" "$model" "$RESET"
printf '%s  %s · started %s%s\n' "$DIM" "$title" "$(date +%H:%M:%S)" "$RESET"
rule
printf '%s  activity%s\n' "$YELLOW" "$RESET"

start=$SECONDS
"run_$reviewer"
status=$?
elapsed=$((SECONDS - start))

rule
if [[ $status -ne 0 || ! -s $out ]]; then
  printf '%s%s  ✗ failed%s (exit %s, %ss) · log: %s\n\n' "$BOLD" "$RED" "$RESET" "$status" "$elapsed" "$out.err"
  tail -n 20 "$out.err" 2>/dev/null
  [[ $status -ne 0 ]] && exit "$status"
  exit 1
fi

render "$out"
rule
if [[ -s $out.denied ]]; then
  printf '%s%s  ⚠ %s denied reads%s → %s\n' "$BOLD" "$RED" "$(wc -l < "$out.denied" | tr -d ' ')" "$RESET" "${out##*/}.denied"
fi
if [[ $(tr -d '[:space:]' < "$out") == "${CLEAN_SENTINEL// /}" ]]; then
  printf '%s%s  ✓ clean%s  %s%ss · %s%s\n' "$BOLD" "$GREEN" "$RESET" "$DIM" "$elapsed" "${out##*/}" "$RESET"
else
  printf '%s%s  ● findings%s → triage in main session  %s%ss · %s%s\n' "$BOLD" "$YELLOW" "$RESET" "$DIM" "$elapsed" "${out##*/}" "$RESET"
fi
