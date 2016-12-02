
extends Node

const DIR = preload('directions.gd')
const ACT = preload('actions.gd')

onready var player = get_node('Player')
onready var input = get_node('/root/input')
onready var camera = get_node('Player/Camera')

const EPSILON = 1e-40

func load_camera():
	camera.set_enable_follow_smoothing(true)
	camera.set_follow_smoothing(7)
	camera.make_current()

func _ready():
	load_camera()
	get_node('StreamPlayer').set_volume(1)
	input.connect('press_quit', self, 'quit')
	input.connect('press_reset', self, 'reset')
	input.connect('press_respawn', self, 'respawn')
	set_fixed_process(true)

func reset():
	global.respawn = Vector2(0, 0)
	get_tree().change_scene('res://resources/scenes/main.tscn')

func respawn():
	get_tree().change_scene('res://resources/scenes/main.tscn')

func quit():
	get_tree().quit()

func _fixed_process(delta):
	check_camera()

func check_camera():
	var tween = Tween.new()
	player.add_child(tween)
	var dir = input._get_direction(Input)
	var act = input._get_action(Input)
	if (act == ACT.CAMERA):
		if (dir == DIR.RIGHT):
			move_camera(tween, Vector2(0, 0), Vector2(140, 0))
		if (dir == DIR.LEFT):
			move_camera(tween, Vector2(0, 0), Vector2(-140, 0))
		if (dir == DIR.UP_RIGHT):
			move_camera(tween, Vector2(0, 0), Vector2(140, -140))
		if (dir == DIR.UP_LEFT):
			move_camera(tween, Vector2(0, 0), Vector2(-140, -140))
		if (dir == DIR.DOWN_RIGHT):
			move_camera(tween, Vector2(0, 0), Vector2(140, 160))
		if (dir == DIR.DOWN_LEFT):
			move_camera(tween, Vector2(0, 0), Vector2(-140, 160))
		if (dir == DIR.UP):
			move_camera(tween, Vector2(0, 0), Vector2(0, -140))
		if (dir == DIR.DOWN):
			move_camera(tween, Vector2(0, 0), Vector2(0, 160))
	elif (act != ACT.CAMERA and (dir == -1 or dir == DIR.RIGHT or dir == DIR.LEFT)):
		move_camera(tween, camera.get_pos(), Vector2(0, 0))

func move_camera(tween, init, final):
	tween.interpolate_property(get_node('Player/Camera'), 'transform/pos', \
		init, final, EPSILON, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
