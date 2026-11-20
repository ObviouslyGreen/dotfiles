#!/usr/bin/env bash
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Directory name
dir="${cwd##*/}"

# Git branch + status (cached for 5s)
CACHE_FILE="/tmp/statusline-git-cache"
CACHE_MAX_AGE=5

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] || \
  [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}

if cache_is_stale; then
  if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    staged=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    echo "${branch}|${staged}|${modified}" > "$CACHE_FILE"
  else
    echo "||" > "$CACHE_FILE"
  fi
fi

IFS='|' read -r branch staged modified < "$CACHE_FILE"
git_info=""
if [ -n "$branch" ]; then
  git_status=""
  [ "$staged" -gt 0 ] && git_status=" ${GREEN}+${staged}${RESET}"
  [ "$modified" -gt 0 ] && git_status="${git_status} ${YELLOW}~${modified}${RESET}"
  git_info=" | ${branch}${git_status}"
fi

# Line 1: [model] 📁 dir | branch +staged ~modified
printf '%b\n' "${CYAN}[${model}]${RESET} ${dir}${git_info}"

# Line 2: progress bar, cost, duration
if [ "$used_pct" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$used_pct" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

BAR_WIDTH=20
FILLED=$((used_pct * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

cost_fmt=$(printf '$%.2f' "$cost")
mins=$((duration_ms / 60000))
secs=$(((duration_ms % 60000) / 1000))

printf '%b\n' "${BAR_COLOR}${BAR}${RESET} ${used_pct}% | ${CYAN}${cost_fmt}${RESET} | ${mins}m ${secs}s"
