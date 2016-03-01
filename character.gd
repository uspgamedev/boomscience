
extends RigidBody2D

var pos_x
var pos_y

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	pos_x = get_pos().x
	pos_y = get_pos().y
	if (Input.is_key_pressed(KEY_RIGHT)):
		self.set_pos(Vector2(pos_x + delta*3*60, pos_y))
	if (Input.is_key_pressed(KEY_LEFT)):
		self.set_pos(Vector2(pos_x - delta*3*60, pos_y))
	if (Input.is_key_pressed(KEY_UP)):
		self.set_linear_velocity(Vector2(0, -100))
		


