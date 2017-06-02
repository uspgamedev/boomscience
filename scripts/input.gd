
extends Node

const DIR = preload('directions.gd')
const ACT = preload('actions.gd')
const ACTIONS = [
	"ui_accept",
	"ui_cancel",
	"ui_camera",
	"ui_stealth",
	"ui_jump",
	"ui_instructions",
	"ui_interact",
	"ui_switch"
]
const INVALID = -1

signal hold_direction(dir)
signal hold_action(act)
signal press_direction(dir)
signal press_action(act)
signal release_direction(dir)
signal release_action(act)

class InputHandler:
	var input_object
	func _init(e):
		input_object = e
	func handle(action_name):
		pass

class HoldInputHandler extends InputHandler:
	func handle(action_name):
		return input_object.is_action_pressed(action_name)

class PressInputHandler extends InputHandler:
	func handle(action_name):
		return input_object.is_action_pressed(action_name)

class ReleaseInputHandler extends InputHandler:
	func handle(action_name):
		return input_object.is_action_released(action_name)

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	var pressed_dir = _get_direction(event, "pressed")
	var pressed_act = _get_action(event, "pressed")
	var released_dir = _get_direction(event, "released")
	var released_act = _get_action(event, "released")
	if pressed_dir != DIR.INVALID: emit_signal('press_direction', pressed_dir)
	if pressed_act != ACT.INVALID: emit_signal('press_action', pressed_act)
	if released_dir != DIR.INVALID: emit_signal('release_action', released_dir)
	if released_act != ACT.INVALID: emit_signal('release_action', released_act)
	do_your_weird_thing(event, pressed_act)

func _fixed_process(delta):
	var held_dir = _get_direction(Input, "held")
	var held_act = _get_action(Input, "held")
	if held_dir != ACT.INVALID: emit_signal('hold_direction', held_dir)
	if held_act != ACT.INVALID: emit_signal('hold_action', held_act)

func is_action_held(action):
	var held_act = _get_action(Input, "held")
	return held_act == action

func is_direction_held(direction):
	var held_dir = _get_direction(Input, "held")
	return held_dir == direction

func _get_action(e, interaction):
	var act = ACT.INVALID
	var check_action

	if not interaction: return

	# configure action handler
	if interaction == "pressed":
		check_action = PressInputHandler.new(e)
	elif interaction == "released":
		check_action = ReleaseInputHandler.new(e)
	elif interaction == "held":
		check_action = HoldInputHandler.new(e)

	# check input with set handler
	for idx in range(ACTIONS.len()):
		if check_action.handle(ACTIONS[idx]):
			return act

	return act

func _get_throw(e):
	var throw = -1
	if e.is_action_pressed('ui_throw'):
		throw = ACT.THROW
	return throw

func _get_direction(e, interaction):
	var dir = DIR.INVALID

	if not interaction: return

	# configure action handler
	if interaction == "pressed":
		check_action = PressInputHandler.new(e)
	elif interaction == "released":
		check_action = ReleaseInputHandler.new(e)
	elif interaction == "held":
		check_action = HoldInputHandler.new(e)

	# check input with set handler
	if check_action.handle('ui_up'):
		dir += DIR.UP
	if check_action.handle('ui_right'):
		dir += DIR.RIGHT
	if check_action.handle('ui_down'):
		dir += DIR.DOWN
	if check_action.handle('ui_left'):
		dir += DIR.LEFT

	return dir

func do_your_weird_thing(event, act):
	var throw = _get_throw(event)
	if throw != ACT.INVALID: emit_signal('press_bomb_throw', throw)
	if act != ACT.INVALID: emit_signal('press_respawn', act)
	if _get_quit(event): emit_signal('press_quit')
	if _get_reset(event): emit_signal('press_reset')
	if _get_respawn(event): emit_signal('press_respawn')

func _get_reset(e):
	if e.is_action_pressed('ui_reset'):
		return true

func _get_respawn(e):
	if e.is_action_pressed('ui_respawn'):
		return true

func _get_quit(e):
	if e.is_action_pressed('ui_quit'):
		return true

