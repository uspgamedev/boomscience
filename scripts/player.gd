extends "res://scripts/body.gd"

func _ready():
	set_fixed_process(true)
	get_node("/root/input").connect('press_action', self, '_jump')
	get_node("/root/input").connect('hold_action', self, '_add_jump_height')
	get_node("/root/input").connect('hold_direction', self, '_add_speed')
