
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
	if (Input.is_key_pressed(KEY_RIGHT)):
		set_linear_velocity(Vector2(200, get_linear_velocity().y))
		direction = 1
	elif (Input.is_key_pressed(KEY_LEFT)):
		set_linear_velocity(Vector2(-200, get_linear_velocity().y))
		direction = -1
	else:
		set_linear_velocity(Vector2(0, get_linear_velocity().y))
	if (Input.is_key_pressed(KEY_UP) and is_jumping == false):
		is_jumping = true
		self.set_linear_velocity(Vector2(0, -500))

func _on_RigidBody2D_body_enter(body):
	is_jumping = false
	
func _input(event):
	print (event.scancode)
	if(event.is_action_pressed("throw")):
		var bomb = bomb_scn.instance()
		bomb.set_pos(Vector2(pos_x, pos_y))
		bomb.set_linear_velocity(Vector2(200 * direction, -500) + get_linear_velocity())
		get_parent().add_child(bomb)
	