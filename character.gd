
extends RigidBody2D

var pos_x
var pos_y
var bomb_scn = preload("res://bomb.xscn")
var enemy_scn = preload("res://enemy.xscn")
var direction = 1  #1 é direita e -1 é esquerda
var sprite

var life_bar
var life = 100
var bomb_select = 1

var cd_count = [0, 0, 0, 0]
var cd_max = [0.5, 3, 0.1, 10]

var anim = "idle"
var anim_new

var state = {
	trans = Tween.TRANS_LINEAR,
	eases = Tween.EASE_IN,
}

var is_jumping = false
var stealth = false

func _ready():
	get_node("RayCast2D").add_exception(self)

	set_fixed_process(true)
	set_process_input(true)
	sprite = get_node("character")

	for i in range(0,4):
		cd_count[i] = cd_max[i]

func _fixed_process(delta):
	stealth = (Input.is_action_pressed("stealth") and !is_jumping)
	
	if direction == 1:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
		
	pos_x = get_pos().x
	pos_y = get_pos().y
	if (Input.is_key_pressed(KEY_D)):
		if (!stealth):
			move(40)
		else:
			move(20)
		direction = 1
	elif (Input.is_key_pressed(KEY_A)):
		if (!stealth):
			move(-40)
		else:
			move(-20)
		direction = -1
	else:
		move(0)
		anim_new = "idle"

	if (get_node("RayCast2D").is_colliding()):
		self.set_friction(1)
		is_jumping = false
	else:
		self.set_friction(0)
		is_jumping = true
	
	if (Input.is_key_pressed(KEY_W) and is_jumping == false):
		is_jumping = true
		set_linear_velocity(Vector2(get_linear_velocity().x, -500))

	if is_jumping:
		anim_new = "jump"

	if anim != anim_new:
		anim = anim_new
		get_node("character/anim").play(anim)
		
	if (get_linear_velocity().x > 220 and !stealth):
		set_linear_velocity(Vector2(220, get_linear_velocity().y))
	elif (get_linear_velocity().x < -220 and !stealth):
		set_linear_velocity(Vector2(-220, get_linear_velocity().y))
	elif (get_linear_velocity().x > 110 and stealth):
		set_linear_velocity(Vector2(110, get_linear_velocity().y))
	elif (get_linear_velocity().x < -110 and stealth):
		set_linear_velocity(Vector2(-110, get_linear_velocity().y))

	for i in range(0,4):
		cd_count[i] += delta

	if (life <= 0):
		death()

func death():
	get_tree().change_scene("res://boomscience.xscn")

func move(speed):
	anim_new = "walk"
	apply_impulse(Vector2(0, 0), Vector2(speed, 0))

func _on_RigidBody2D_body_enter(body):
	if (body.is_in_group("enemies")):
		life -= 20
		if (body.get_pos() <= self.get_pos()):
			set_linear_velocity(Vector2(600, -200))
		else:
			set_linear_velocity(Vector2(-600, -200))
	
func _input(event):
	if(event.is_action_pressed("throw")):
		throw(bomb_select, cd_max[bomb_select-1])
	if(event.is_action_pressed("select_basic")):
		bomb_select = 1
	if(event.is_action_pressed("select_fire")):
		bomb_select = 2
	if(event.is_action_pressed("select_ice")):
		bomb_select = 3
	if(event.is_action_pressed("select_water")):
		bomb_select = 4

func throw(bomb_type, cooldown):
	if cd_count[bomb_select-1] >= cooldown:
		cd_count[bomb_select-1] = 0
		var screen_center = Vector2(get_viewport_rect().size.width, get_viewport_rect().size.height)/2
		var mouse_dir = get_viewport().get_mouse_pos() - screen_center
		var offset = get_pos() - get_node("Camera2D").get_camera_pos()
		var bomb_direction = mouse_dir - offset
		var bomb = bomb_scn.instance()
		var angulation_y = max(bomb_direction.length() * -1.5, -500)
		var angulation_x = max(bomb_direction.length()/150, 1.5)
		var vel_x = angulation_x * bomb_direction.x + 100
		var vel_y = angulation_y + bomb_direction.y

		bomb.set_pos(get_pos())
		bomb.set_linear_velocity(Vector2(vel_x,vel_y))
		get_parent().add_child(bomb)

func bomb_value():
	return bomb_select

func color_change (before, after, t):
	var tween = get_node("lifebar/Tween")
	var sprite = get_node("character")

	get_node("lifebar/VBoxContainer/color_from").set_color(before)
	
	get_node("lifebar/VBoxContainer/color_to").set_color(after)
	
	var color_from = get_node("lifebar/VBoxContainer/color_from").get_color()
	var color_to = get_node("lifebar/VBoxContainer/color_to").get_color()
	
	tween.interpolate_method(sprite, "set_modulate", color_from, color_to, t, state.trans, state.eases)
	
	tween.set_repeat(false)
	tween.start()

func get_stealth():
	return stealth