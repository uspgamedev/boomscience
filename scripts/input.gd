
extends Node

const DIR = preload('directions.gd')
const ACT = preload('actions.gd')
const INVALID = -1

signal hold_direction(dir)
signal hold_action(act)
signal press_direction(dir)
signal press_action(act)
signal release_direction(dir)
signal release_action(dir)

# WEIRD AS FUCK HARDCODED STUFF WHY WOULD YOU DO THIS
signal press_quit
signal press_reset
signal press_respawn
signal press_bomb_throw

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	var pressed_dir = _get_direction(event, "pressed")
	var pressed_act = _get_action(event, "pressed")
	var released_dir = _get_direction(event, "released")
	var released_act = _get_action(event, "released")
	if pressed_dir != INVALID: emit_signal('press_direction', pressed_dir)
	if pressed_act != INVALID: emit_signal('press_action', pressed_act)
	if released_dir != INVALID: emit_signal('release_action', released_dir)
	if released_act != INVALID: emit_signal('release_action', released_act)
	do_your_weird_thing(event, pressed_act)

func _fixed_process(delta):
	var held_dir = _get_direction(Input, "held")
	var held_act = _get_action(Input, "held")
	if held_dir != INVALID: emit_signal('hold_direction', held_dir)
	if held_act != INVALID: emit_signal('hold_action', held_act)

func _get_action(e, interaction):
	var act = INVALID
	var check_action = FuncRef.new()

	if not interaction: return

	# configure funcref's target object and method
	check_action.set_instance(e)
	if interaction == "pressed":
		check_action.set_function("is_action_pressed")
	elif interaction == "released":
		check_action.set_function("is_action_released")
	elif interaction == "held":
		check_action.set_function("is_action_pressed")

	# check input with set interaction
	if check_action.call_func('ui_accept'):
		act = ACT.ACCEPT
	if check_action.call_func('ui_cancel'):
		act = ACT.CANCEL
	if check_action.call_func('ui_camera'):
		act = ACT.CAMERA
	if check_action.call_func('ui_stealth'):
		act = ACT.STEALTH
	if check_action.call_func('ui_jump'):
		act = ACT.JUMP
	if check_action.call_func('ui_instructions'):
		act = ACT.INST
	if check_action.call_func('ui_interact'):
		act = ACT.INTERACT
	if check_action.call_func('ui_switch'):
		act = ACT.SWITCH

	return act

func _get_throw(e):
	var throw = -1
	if e.is_action_pressed('ui_throw'):
		throw = ACT.THROW
	return throw

func _get_direction(e, interaction):
	var dir = INVALID
	var check_action = FuncRef.new()

	if not interaction: return

	# configure funcref's target object and method
	check_action.set_instance(e)
	if interaction == "pressed":
		check_action.set_function("is_action_pressed")
	elif interaction == "released":
		check_action.set_function("is_action_released")
	elif interaction == "held":
		check_action.set_function("is_action_pressed")

	# check input with set interaction
	if check_action.call_func('ui_up') and not check_action.call_func('ui_down'):
		dir = DIR.UP
	elif check_action.call_func('ui_down') and not check_action.call_func('ui_up'):
		dir = DIR.DOWN
	if check_action.call_func('ui_right') and not check_action.call_func('ui_left'):
		dir = DIR.RIGHT
	elif check_action.call_func('ui_left') and not check_action.call_func('ui_right'):
		dir = DIR.LEFT
	if check_action.call_func('ui_up') and check_action.call_func('ui_right') \
		and not check_action.call_func('ui_down') and not check_action.call_func('ui_left'):
		dir = DIR.UP_RIGHT
	elif check_action.call_func('ui_down') and check_action.call_func('ui_left') \
		and not check_action.call_func('ui_up') and not check_action.call_func('ui_right'):
		dir = DIR.DOWN_LEFT
	if check_action.call_func('ui_down') and check_action.call_func('ui_right') \
		and not check_action.call_func('ui_up') and not check_action.call_func('ui_left'):
		dir = DIR.DOWN_RIGHT
	elif check_action.call_func('ui_up') and check_action.call_func('ui_left') \
		and not check_action.call_func('ui_down') and not check_action.call_func('ui_right'):
		dir = DIR.UP_LEFT

	return dir

func do_your_weird_thing(event, act):
	var throw = _get_throw(event)
	if throw != INVALID: emit_signal('press_bomb_throw', throw)
	if act != INVALID: emit_signal('press_respawn', act)
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

