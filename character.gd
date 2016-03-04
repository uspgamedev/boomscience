
extends RigidBody2D

var pos_x
var pos_y
var bomb_scn = preload("res://bomb.xscn")

var is_jumping = true

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	pos_x = get_pos().x
	pos_y = get_pos().y
	if (Input.is_key_pressed(KEY_RIGHT)):
		self.set_pos(Vector2(pos_x + 3, pos_y))
	if (Input.is_key_pressed(KEY_LEFT)):
		self.set_pos(Vector2(pos_x - 3, pos_y))
	if (Input.is_key_pressed(KEY_UP) and is_jumping == false):
		is_jumping = true
		self.set_linear_velocity(Vector2(0, -300))

func _on_RigidBody2D_body_enter(body):
	is_jumping = false
	
func _input(event):
	if(event.is_action_pressed("throw")):
		var bomb = bomb_scn.instance()
		bomb.set_pos(Vector2(pos_x, pos_y))
		bomb.set_linear_velocity(Vector2(200, -300))
		get_parent().add_child(bomb)
	