extends 'res://scripts/body.gd'

const Door = preload("res://scripts/door.gd")

const ACT = preload('actions.gd')
var bomb_scn = preload('../resources/scenes/bomb.tscn')

onready var input = get_node('/root/input')
onready var global = get_node('/root/global')
onready var area = get_node('PlayerAreaDetection')
var key = [0, 0, 0, 0]

var anim = 'idle'
var anim_new
var bomb_cooldown = 0
var bomb_direction

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	input.connect('hold_direction', self, '_flip_sprite')
	area.connect('area_enter', self, '_on_Area2D_area_enter')
	area.connect('body_enter', self, '_on_Area2D_body_enter')
	area.connect('area_exit',self,'_on_Area2D_area_exit')
	hp = 500
	sprite = get_node('PlayerSprite')
	self.set_pos(global.respawn)
	set_fixed_process(true)

func _fixed_process(delta):
	check_camera()
	check_stealth()
	check_animation()
	check_bomb_throw()
	check_stairs()

func check_stairs():
	var stairs = get_node('../BasicTilemap/Stairs')
	var act = input._get_action(Input)
	if (stairs.get_cellv(stairs.world_to_map(self.get_pos())) != -1):
		G = 0
		acc = .4 * acc
		var dir = input._get_direction(Input)
		if (act != ACT.CAMERA):
			if (dir == DIR.UP):
				speed.y -= 30
			elif (dir == DIR.DOWN):
				speed.y += 30
			else:
				speed.y = 0
	else:
		G = 3000
		if (act != ACT.STEALTH):
			acc = ACC

func check_camera():
	var act = input._get_action(Input)
	if (act == ACT.CAMERA):
		if (input.is_connected('hold_direction', self, '_add_speed')):
			input.disconnect('hold_direction', self, '_add_speed')
	elif (act == -1):
		if (!input.is_connected('hold_direction', self, '_add_speed')):
			input.connect('hold_direction', self, '_add_speed')

func check_stealth():
	var act = input._get_action(Input)
	if (act == ACT.STEALTH):
		area.set_scale(Vector2(.3, .3))
		sprite.set_modulate(Color(1, 1, 1, .5))
		acc = .5 * ACC
	else:
		area.set_scale(Vector2(1, 1))
		sprite.set_modulate(Color(1, 1, 1, 1))
		acc = ACC

func check_animation():
	if (can_jump and !speed.x):
		anim_new = 'idle'
	elif (!can_jump):
		anim_new = 'jump'
	elif (speed.x):
		anim_new = 'walk'
	if (anim != anim_new):
		anim = anim_new
		get_node('PlayerSprite/PlayerAnimation').play(anim)

func check_bomb_throw():
	if (bomb_cooldown == 0):
		var act = input._get_throw(Input)
		if (act == ACT.THROW):
			var fx = get_node('../SamplePlayer')
			fx.set_default_volume(.3)
			fx.play('throw')
			bomb_cooldown = 1
			var screen_center = Vector2(get_viewport_rect().size.width, get_viewport_rect().size.height)/2
			var mouse_dir = get_viewport().get_mouse_pos() - screen_center
			var offset = get_pos() - get_node('Camera').get_camera_pos()
			bomb_direction = mouse_dir - offset
			var bomb = bomb_scn.instance()
			bomb.set_pos(self.get_pos())
			get_parent().add_child(bomb)
	elif (bomb_cooldown >= 1):
		bomb_cooldown += 1
		if (bomb_cooldown > 20):
			bomb_cooldown = 0

func _on_Area2D_area_enter(area):
	check_keys(area)
	check_doors(area)
	check_death(area)
	check_damage(area)

func _on_Area2D_body_enter(area):
	pass

func check_damage(area):
	var area_node = area.get_node('../')
	if (area_node.is_in_group('enemy')):
		hp -= 100
		knockback(area_node)
	if (hp <= 0):
		global.death_count += 1
		get_tree().change_scene('res://resources/scenes/main.tscn')

func knockback(area_node):
	var vector = self.get_pos() - area_node.get_pos()
	speed.x += .5 * ACC * vector.x
	speed.y -= 5 * ACC - 20 * vector.y

func check_keys(area):
	check_key_name(area, 'Key1', 0)
	check_key_name(area, 'Key2', 1)
	check_key_name(area, 'Key3', 2)
	check_key_name(area, 'Key4', 3)

func check_key_name(area, key_name, key_index):
	if (area.get_node('../').get_name() == key_name):
		var fx = get_node('../SamplePlayer')
		key[key_index] = 1
		fx.set_default_volume(.3)
		fx.play('confirmation')
		area.get_node('../').queue_free()

func check_doors(area):
	var door = area.get_parent()
	if ((global.stage == 0 and key[0] == 1) or \
		(global.stage == 1 and key[1] == 1) or \
		(global.stage == 2 and key[2] == 1) or \
		(global.stage == 3 and key[3] == 1)):
		if (door.get_script() == Door):
			var target = door.get_target()
			var fx = get_node('../SamplePlayer')
			fx.set_default_volume(.3)
			if (target != null):
				fx.play('confirmation')
				global.stage += 1
				global.respawn = target
				self.set_pos(global.respawn)
			else:
				if (get_node('Congratulations').get_scale() != Vector2(1, 1)):
					fx.play('confirmation')
				global.stop_chronometer()
				get_node('Congratulations').set_scale(Vector2(1, 1))

func check_death(area):
	if (area.get_name() == 'Death'):
		global.death_count += 1
		get_tree().change_scene('res://resources/scenes/main.tscn')
