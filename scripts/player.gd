extends "res://scripts/body.gd"

const DIR = preload("directions.gd")

const ACC = 3

var _ref_dirs = DIR.new()
onready var input = get_node("/root/input")

func ready():
	set_fixed_process(true)

func _fixed_process(delta):
	self._apply_speed(delta)

func _apply_speed(delta):
	if (input.dir >= 0):
		self.v += _ref_dirs.get_dir(input.dir) * ACC
