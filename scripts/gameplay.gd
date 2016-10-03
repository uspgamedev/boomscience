
extends Node

const DIR = preload("directions.gd")

onready var player = get_node('Player')
onready var input = get_node('/root/input')
var camera

func load_camera():
	camera = Camera2D.new()
	camera.set_enable_follow_smoothing(true)
	camera.set_follow_smoothing(5)
	player.add_child(camera)
	camera.make_current()

func _ready():
	load_camera()
	input.connect('press_quit', self, 'quit')
	set_fixed_process(true)

func quit():
	get_tree().quit()

func _fixed_process(delta):
	_move_camera()

func _move_camera():
	var dir = input._get_direction(Input)
	if (dir == DIR.UP or dir == DIR.UP_LEFT or dir == DIR.UP_RIGHT):
		camera.set_offset(Vector2(0, -140))
	elif (dir == DIR.DOWN or dir == DIR.DOWN_LEFT or dir == DIR.DOWN_RIGHT):
		camera.set_offset(Vector2(0, 160))
	elif (dir == -1 or dir == DIR.LEFT or dir == DIR.RIGHT):
		camera.set_offset(Vector2(0, 0))
