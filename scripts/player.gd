extends "res://scripts/body.gd"

func _ready():
	set_fixed_process(true)
	get_node("/root/input").connect('hold_direction', self, '_add_speed')
	get_node("/root/input").connect('press_direction', self, 'jump')

func _fixed_process(delta):
	pass
