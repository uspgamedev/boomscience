
extends RigidBody2D

var pos_x
var pos_y
var bomb_scn = preload("res://bomb.xscn")
var enemy_scn = preload("res://enemy.xscn")
var direction = 1  #1 é direita e -1 é esquerda
var sprite
var life = 100

var is_jumping = false

func _ready():
	get_node("RayCast2D").add_exception(self)
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
		move(220, 10, delta)
		direction = 1
	elif (Input.is_key_pressed(KEY_A)):
		move(-220, 10, delta)
		direction = -1
	else:
		move(0, 10, delta)
	if (get_node("RayCast2D").is_colliding()):
		is_jumping = false
	if (Input.is_key_pressed(KEY_W) and is_jumping == false):
		is_jumping = true
		set_linear_velocity(Vector2(get_linear_velocity().x, -500))
	if (life <= 0):
		get_tree().change_scene("res://boomscience.xscn")

func move(speed, acceleration, delta):
	var current_speed_x = get_linear_velocity().x
	current_speed_x = lerp(current_speed_x, speed, acceleration * delta)
	set_linear_velocity(Vector2(current_speed_x, get_linear_velocity().y))

func _on_RigidBody2D_body_enter(body):
	if (body.is_in_group("enemies")):
		life -= 35
		if (body.get_pos() <= self.get_pos()):
			apply_impulse(Vector2(0, 0), Vector2(1000, -200))
		else:
			apply_impulse(Vector2(0, 0), Vector2(-1000, -200))
	
func _input(event):
	if(event.is_action_pressed("throw")):
		var screen_center = Vector2(get_viewport_rect().size.width, get_viewport_rect().size.height)/2
		var mouse_dir = get_viewport().get_mouse_pos() - screen_center
		var offset = get_pos() - get_node("Camera2D").get_camera_pos()
		var bomb_direction = mouse_dir - offset
		var bomb = bomb_scn.instance()
		var angulation_y = max(bomb_direction.length() * -1 * 1.5, -500)
		var angulation_x = max(bomb_direction.length()/150, 1.5)
		var vel_x = angulation_x * bomb_direction.x + 100
		var vel_y = angulation_y + bomb_direction.y
		var limit = 500
		bomb.set_pos(get_pos())
		if (vel_x > limit):
			vel_x = limit
		elif (vel_x <= -limit):
			vel_x = -limit
		if (vel_y > limit):
			vel_y = limit
		elif (vel_y <= -limit):
			vel_y = -limit
		bomb.set_linear_velocity(Vector2(vel_x,vel_y))
		get_parent().add_child(bomb)
	if(event.is_action_pressed("instance")):
		var enemy = enemy_scn.instance()
		enemy.set_pos(get_viewport().get_mouse_pos())
		get_parent().add_child(enemy)
	