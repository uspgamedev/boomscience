
extends RigidBody2D

var pos_x
var pos_y
var bomb_scn = preload("res://bomb.xscn")
var enemy_scn = preload("res://enemy.xscn")
var direction = 1  #1 é direita e -1 é esquerda
var sprite
var vel_limit = 250

var is_jumping = false

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	sprite = get_node("character")
	
func _fixed_process(delta):
	if direction == 1:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
		
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
		var erro = get_pos().x - get_node("Camera2D").get_camera_pos().x
		var screen_size = Vector2(get_viewport_rect().size.width + 2*erro, get_viewport_rect().size.height)
		var bomb = bomb_scn.instance()
		var bomb_direction = Vector2(0, 0)
		# talvez seja possível fazer a multiplicação do vetro por -1
		if get_viewport().get_mouse_pos().x >= screen_size.x/2:
			bomb_direction.x = get_viewport().get_mouse_pos().x 
			bomb_direction.y = get_viewport().get_mouse_pos().y
		else:
			bomb_direction.x = -screen_size.x/2 + get_viewport().get_mouse_pos().x
			bomb_direction.y = get_viewport().get_mouse_pos().y
		bomb.set_pos(get_pos())
		bomb.set_linear_velocity(2 * Vector2(bomb_direction.x, -screen_size.y + bomb_direction.y))
		get_parent().add_child(bomb)
	if(event.is_action_pressed("instance")):
		var enemy = enemy_scn.instance()
		enemy.set_pos(get_viewport().get_mouse_pos())
		get_parent().add_child(enemy)
	
