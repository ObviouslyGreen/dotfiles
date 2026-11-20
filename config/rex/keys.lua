-- PANE FOCUS (WezTerm: CMD+hjkl)
-- cmd+k replaces Rex's default session picker; it moves to ctrl+a>shift+k.
-- cmd+h may still be taken by macOS "Hide Rex Beta"; alt+cmd+arrows is Rex's default focus.
rex.bind("cmd+h", "pane.focus", { direction = "left" })
rex.bind("cmd+l", "pane.focus", { direction = "right" })
rex.bind("cmd+k", "pane.focus", { direction = "up" })
rex.bind("cmd+j", "pane.focus", { direction = "down" })

-- LEADER (WezTerm: CTRL+a). Rex sequences have no timeout; Escape cancels.
local LEADER = "ctrl+a"
local function leader(key) return LEADER .. ">" .. key end

rex.bind(leader("ctrl+a"), "pane.send_key", { key = "ctrl+a" })
rex.bind(leader("k"), "com.superlogical.terminal.clear")
rex.bind(leader("shift+k"), "session.switch")
rex.bind(leader("i"), "pane.split", { direction = "down" })
rex.bind(leader("s"), "pane.split", { direction = "right" })

local RESIZE_STEP = 5
for _, direction in ipairs({ "left", "right", "up", "down" }) do
  rex.bind(leader(direction), "pane.resize", { direction = direction, amount = RESIZE_STEP })
end

-- RESIZE MODE: ctrl+a>r, then arrows (shift for bigger steps), = to balance, Escape or Enter to leave.
local RESIZE_STEP_LARGE = 15
rex.mode("resize", { exclusive = true })
rex.bind(leader("r"), "client.mode.enter", { name = "resize" })
for _, direction in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("resize/" .. direction, "pane.resize", { direction = direction, amount = RESIZE_STEP })
  rex.bind("resize/shift+" .. direction, "pane.resize", { direction = direction, amount = RESIZE_STEP_LARGE })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

-- iTerm2 natural text editing
rex.bind("alt+left", "pane.send_key", { key = "alt+b" })
rex.bind("alt+right", "pane.send_key", { key = "alt+f" })
rex.bind("cmd+left", "pane.send_key", { key = "ctrl+a" })
rex.bind("cmd+right", "pane.send_key", { key = "ctrl+e" })
rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" })
