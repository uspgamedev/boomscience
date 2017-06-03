
extends Node

enum CONSOLE_LIKE {
	INVALID = -1,
	KEY_Z,   # yes
	KEY_X,   # no
	KEY_C,   # attack
	SPACE,   # jump
	CONTROL, # camera
	KEY_F,   # toggle change prev
	KEY_G,   # toggle change next
	ESCAPE,  # pause
	F1,      # help
	F2,      # debug respawn
	F3,      # debug reset
	COUNT
}

enum FPS_LIKE {
	KEY_E = KEY_Z, # yes
	CLICK_2,       # no
	CLICK_1,       # attack
	SPACE,         # jump
	CONTROL,       # camera
	KEY_Q,         # toggle change prev
	SHIFT,         # toggle change next
	ESCAPE,        # pause
	F1,            # help
	F2,            # debug respawn
	F3,            # debug reset
	COUNT
}

const ACTIONS = {
	KEY_Z:   "yes",
	KEY_X:   "no",
	KEY_C:   "attack",
	SPACE:   "jump",
	CONTROL: "camera",
	KEY_F:   "toggle_prev",
	KEY_G:   "toggle_next",
	ESCAPE:  "pause",
	F1:      "help",
	F2:      "debug_respawn",
	F3:      "debug_reset"
}

