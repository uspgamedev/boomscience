extends "res://scripts/body.gd"

const DIR = preload("directions.gd")

const ACC = 3

var _ref_dirs = DIR.new()

func _ready():
	set_fixed_process(true)
	get_node("/root/input").connect('hold_direction', self, '_on_hold_direction')

func _fixed_process(delta):
	pass

func _on_hold_direction(dir):
	_apply_speed(_ref_dirs.get_dir(dir))

func _apply_speed(dir):
	self.v += dir * ACC
