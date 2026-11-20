#!/usr/bin/env bash
# Focus a specific WezTerm pane and raise the app to the front.
# Called from the notification click action ($1 = pane id, $2 = gui socket path).

pane="$1"
sock="$2"
wezterm_bin=$(command -v wezterm || echo /opt/homebrew/bin/wezterm)

open -a WezTerm
WEZTERM_UNIX_SOCKET="$sock" "$wezterm_bin" cli activate-pane --pane-id "$pane" 2>/dev/null || true
