extends Node2D

export(String) var flag_name = null
export(String) var initial_state = null
export(String) var alternate_state = null

onready var global = get_node('/root/global')

signal toggled(new_state)

func _ready():
	assert(flag_name != null and initial_state != null and alternate_state != null)

func get_state():
	return global.flags[flag_name]

func toggled():
	return get_state() == alternate_state

func set_state(state):
	global.flags[flag_name] = state

func toggle():
	if toggled():
		set_state(initial_state)
	else:
		set_state(alternate_state)
	emit_signal("toggled", get_state())
