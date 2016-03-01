
extends RigidBody2D

var FRAMERATE = 60
var dtotal = 0

var pos_x
var pos_y

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	dtotal += delta
	while dtotal >= 1/FRAMERATE:
		dtotal -= delta
		pos_x = get_pos().x
		pos_y = get_pos().y
		if (Input.is_key_pressed(KEY_RIGHT)):
			print("right")
			self.set_pos(Vector2(pos_x + 3, pos_y))
		if (Input.is_key_pressed(KEY_LEFT)):
			print("left")
			self.set_pos(Vector2(pos_x - 3, pos_y))
		if (Input.is_key_pressed(KEY_UP)):
			self.set_linear_velocity(Vector2(0, -100))


