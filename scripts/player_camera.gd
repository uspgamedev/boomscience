extends Camera2D

const ACT = preload('res://scripts/actions.gd')
const DIR = preload('res://scripts/directions.gd')
onready var tween = get_node('Tween')
onready var input = get_node('/root/input')

const EPSILON = 1e-40

func _ready():
	load_camera()
	set_fixed_process(true)
	
func _fixed_process(delta):
	check_camera()

func load_camera():
	self.set_enable_follow_smoothing(true)
	self.set_follow_smoothing(7)
	self.make_current()

func check_camera():
	if input.is_action_held(ACT.CAMERA):
		if input.is_direction_held(DIR.RIGHT):
			move_camera(tween, Vector2(0, 0), Vector2(140, 0))
		if input.is_direction_held(DIR.LEFT):
			move_camera(tween, Vector2(0, 0), Vector2(-140, 0))
		if input.is_direction_held(DIR.UP_RIGHT):
			move_camera(tween, Vector2(0, 0), Vector2(140, -140))
		if input.is_direction_held(DIR.UP_LEFT):
			move_camera(tween, Vector2(0, 0), Vector2(-140, -140))
		if input.is_direction_held(DIR.DOWN_RIGHT):
			move_camera(tween, Vector2(0, 0), Vector2(140, 160))
		if input.is_direction_held(DIR.DOWN_LEFT):
			move_camera(tween, Vector2(0, 0), Vector2(-140, 160))
		if input.is_direction_held(DIR.UP):
			move_camera(tween, Vector2(0, 0), Vector2(0, -140))
		if input.is_direction_held(DIR.DOWN):
			move_camera(tween, Vector2(0, 0), Vector2(0, 160))
	elif input.is_direction_held(DIR.INVALID) or \
			input.is_direction_held(DIR.RIGHT) or \
			input.is_direction_held(DIR.LEFT):
		move_camera(tween, self.get_pos(), Vector2(0, 0))

func move_camera(tween, init, final):
	tween.interpolate_property(self, 'transform/pos', \
		init, final, EPSILON, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

