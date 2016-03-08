
extends RigidBody2D

var pos_x
var pos_y
var bomb_scn = preload("res://bomb.xscn")
var direction = 1  #1 é direita e -1 é esquerda

var is_jumping = true

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	pos_x = get_pos().x
	pos_y = get_pos().y
	if (Input.is_key_pressed(KEY_D)):
		set_linear_velocity(Vector2(200, get_linear_velocity().y))
		direction = 1
	elif (Input.is_key_pressed(KEY_A)):
		set_linear_velocity(Vector2(-200, get_linear_velocity().y))
		direction = -1
	else:
		set_linear_velocity(Vector2(0, get_linear_velocity().y))
	if (Input.is_key_pressed(KEY_W) and is_jumping == false):
		is_jumping = true
		self.set_linear_velocity(Vector2(0, -500))

func _on_RigidBody2D_body_enter(body):
	is_jumping = false
	
func _input(event):
	if(event.is_action_pressed("throw")):
		var bomb = bomb_scn.instance()
		var bomb_direction = get_viewport().get_mouse_pos() - get_pos()
		var vel_limit = 250
		bomb.set_pos(Vector2(pos_x, pos_y))
		if (bomb_direction.length() <= vel_limit):
			bomb.set_linear_velocity(3 * bomb_direction)
		else:
			bomb.set_linear_velocity(3 * bomb_direction * vel_limit/bomb_direction.length())
		#bomb.set_linear_velocity(Vector2(200 * direction + get_linear_velocity().x/2, -500))
		get_parent().add_child(bomb)
	