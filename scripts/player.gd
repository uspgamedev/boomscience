extends 'res://scripts/body.gd'

const Door = preload("res://scripts/door.gd")
const Valve = preload("res://scripts/valve.gd")
const Lever = preload("res://scripts/lever.gd")

const ACT = preload('actions.gd')
const HE_BOMB = 0
const SMOKE_BOMB = 1
var bombs = [
	preload('../resources/scenes/bomb.tscn'),
	preload('../resources/scenes/projectiles/smoke_bomb.tscn')
]
var bomb_scn = null

onready var input = get_node('/root/input')
onready var global = get_node('/root/global')
onready var area_detection = get_node('PlayerAreaDetection')
onready var hitbox_area = get_node('PlayerHitboxArea')
onready var fx = get_node('SamplePlayer')
onready var climb_cooldown = get_node('ClimbCooldown')
onready var damage_cooldown = get_node('DamageCooldown')
onready var he_bomb_cooldown = get_node('HEBombCooldown')
onready var smoke_bomb_cooldown = get_node('SmokeBombCooldown')
onready var ground = get_node("Ground")
onready var hud = get_node('../../Hud')
onready var invslot_view = hud.get_node('CharInfo/InventorySlot')

var anim = 'idle'
var anim_new
var bomb_direction
var nearby_npc
var equipped_bomb = 0
var climbing = false
var can_climb = true
var sprite_alpha = 1

signal equipped_bomb(texture)
signal lever_interaction()

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('press_action', self, '_interact')
	input.connect('press_bomb_throw', self, '_check_bomb_throw')
	input.connect('press_action', self, '_switch_bomb')
	input.connect('press_action', self, '_check_interactable')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	input.connect('hold_direction', self, '_flip_sprite')
	area_detection.connect('area_enter', self, '_on_Area2D_area_enter')
	area_detection.connect('area_exit',self,'_on_Area2D_area_exit')
	self.connect('equipped_bomb', invslot_view, '_change_icon')
	hp = 500
	equip_bomb(0)
	var lifebar = hud.get_node('CharInfo/LifeBar')
	lifebar.set_max(500)
	lifebar.change_life(hp, 0)
	sprite = get_node('PlayerSprite')
	speed = Vector2(0, 0)

func _fixed_process(delta):
	check_camera()
	check_stealth()
	check_animation()
	check_stairs()
	check_damage()

func _interact(act):
	var text = hud.get_node('DialogReader/TextPanel/Text')
	if (!hud.is_dialog_reader_hidden()):
		player_freeze()
		if (act == ACT.INTERACT):
			if (!text.next_page()):
				player_unfreeze()
				hud.hide_dialog_reader()
	elif (nearby_npc != null):
		if (act == ACT.INTERACT):
			if (text.next_page()):
				player_freeze()
				hud.show_dialog_reader()

func _switch_bomb(act):
	if (act == ACT.SWITCH):
		equip_bomb((equipped_bomb + 1)%2)

func equip_bomb(idx):
	bomb_scn = bombs[idx]
	equipped_bomb = idx
	var temp = bomb_scn.instance()
	var sprite = temp.get_node("BombSprite").get_texture()
	emit_signal("equipped_bomb", sprite)

func set_nearby_npc(npc):
	nearby_npc = npc

func able_to_climb(stairs):
	return !climbing and can_climb and stairs.get_cellv(stairs.world_to_map(self.get_pos())) != -1 \
		and (!input.is_direction_held(DIR.INVALID) and !input.is_direction_held(DIR.RIGHT) and \
			 !input.is_direction_held(DIR.LEFT)) \
		and not ((input.is_direction_held(DIR.DOWN) or input.is_direction_held(DIR.DOWN_RIGHT) or \
				  input.is_direction_held(DIR.DOWN_LEFT)) and !ground.get_overlapping_bodies().empty()) \
		and not input.is_action_held(ACT.CAMERA)

func check_stairs():
	var stairs = get_node('../Stairs')
	var anim = get_node('PlayerSprite/PlayerAnimation')
	if (climbing):
		align_stair_axis()
	if (able_to_climb(stairs)):
		climbing = true
		if (!input.is_connected('press_action', self, '_release_stairs')):
			input.connect('press_action', self, '_release_stairs')
		if (!ground.is_connected('body_enter', self, '_touch_ground')):
			ground.connect('body_enter', self, '_touch_ground')
		set_jump(true)
		jump_height = -1
		anim.play('climb')
		if (speed.y < -180):
			speed.y = -180
		if (input.is_connected('hold_direction', self, '_flip_sprite')):
			input.disconnect('hold_direction', self, '_flip_sprite')
	if (stairs.get_cellv(stairs.world_to_map(self.get_pos())) == -1):
		climbing = false
		if (!input.is_connected('hold_direction', self, '_flip_sprite')):
			input.connect('hold_direction', self, '_flip_sprite')
		G = 3000
	elif (climbing):
		G = 0
		if !input.is_action_held(ACT.CAMERA):
			if (speed.y == 0):
				anim.stop()
			if input.is_direction_held(DIR.UP) or input.is_direction_held(DIR.UP_RIGHT) or input.is_direction_held(DIR.UP_LEFT):
				if (!anim.is_playing() and speed.y != 0):
					anim.play('climb')
				if input.is_action_held(ACT.STEALTH):
					speed.y -= 10
				else:
					speed.y -= 20
			elif input.is_direction_held(DIR.DOWN) or input.is_direction_held(DIR.DOWN_RIGHT) or input.is_direction_held(DIR.DOWN_LEFT):
				if (!anim.is_playing() and speed.y != 0):
					anim.play('climb')
				if input.is_action_held(ACT.STEALTH):
					speed.y += 10
				else:
					speed.y += 20
			else:
				speed.y = 0
				anim.stop()
		else:
			speed.y = 0
			anim.stop()

func _touch_ground(body_touched):
	_release_stairs(ACT.JUMP)

func _release_stairs(act):
	if (climbing and act == ACT.JUMP):
		climbing = false
		if (!input.is_connected('hold_direction', self, '_flip_sprite')):
			input.connect('hold_direction', self, '_flip_sprite')
		if (ground.is_connected('body_enter', self, '_touch_ground')):
			ground.disconnect('body_enter', self, '_touch_ground')
		G = 3000
		input.disconnect('press_action', self, '_release_stairs')
		if input.is_direction_held(DIR.RIGHT) or \
				input.is_direction_held(DIR.LEFT) or \
				input.is_direction_held(DIR.UP_LEFT) or \
				input.is_direction_held(DIR.UP_RIGHT):
			set_jump(true)
			_jump(act)
		can_climb = false
		climb_cooldown.start()
		yield(climb_cooldown, 'timeout')
		can_climb = true

func align_stair_axis():
	var stairs = get_node('../Stairs')
	var stair_pos = stairs.map_to_world(stairs.world_to_map(self.get_pos()))
	var stair_width = stairs.get_cell_size().x
	speed.x = 0
	self.set_pos(Vector2(stair_pos.x + stair_width/2, self.get_pos().y))

func player_freeze():
	if (input.is_connected('hold_direction', self, '_add_speed')):
		input.disconnect('hold_direction', self, '_add_speed')
	if (input.is_connected('press_action', self, '_jump')):
		input.disconnect('press_action', self, '_jump')
	if (input.is_connected('press_bomb_throw', self, '_check_bomb_throw')):
		input.disconnect('press_bomb_throw', self, '_check_bomb_throw')

func player_unfreeze():
	if (!input.is_connected('hold_direction', self, '_add_speed')):
		input.connect('hold_direction', self, '_add_speed')
	if (!input.is_connected('press_action', self, '_jump')):
		input.connect('press_action', self, '_jump')
	if (!input.is_connected('press_bomb_throw', self, '_check_bomb_throw')):
		input.connect('press_bomb_throw', self, '_check_bomb_throw')

func check_camera():
	if input.is_action_held(ACT.CAMERA):
		player_freeze()
	elif input.is_action_held(ACT.INVALID) and hud.is_dialog_reader_hidden():
		player_unfreeze()

func check_stealth():
	if input.is_action_held(ACT.STEALTH):
		area_detection.set_scale(Vector2(.3, .3))
		sprite_alpha = .5
		if (!damage_cooldown.get_time_left()):
			sprite.set_modulate(Color(1, 1, 1, sprite_alpha))
		acc = .5 * ACC
	else:
		area_detection.set_scale(Vector2(1, 1))
		sprite_alpha = 1
		if (!damage_cooldown.get_time_left()):
			sprite.set_modulate(Color(1, 1, 1, sprite_alpha))
		acc = ACC

func check_animation():
	if (can_jump and !speed.x):
		anim_new = 'idle'
	elif (climbing):
		anim_new = 'climb'
	elif (!can_jump):
		yield(get_tree(), 'fixed_frame')
		anim_new = 'jump'
	elif (speed.x):
		anim_new = 'walk'
	if (anim != anim_new):
		anim = anim_new
		get_node('PlayerSprite/PlayerAnimation').play(anim)

func _check_bomb_throw(throw):
	if (throw == ACT.THROW):
		if (!he_bomb_cooldown.get_time_left() and equipped_bomb == HE_BOMB):
			bomb_throw()
			he_bomb_cooldown.start()
		elif (!smoke_bomb_cooldown.get_time_left() and equipped_bomb == SMOKE_BOMB):
			bomb_throw()
			smoke_bomb_cooldown.start()

func bomb_throw():
		var screen_center = Vector2(get_viewport_rect().size.width, get_viewport_rect().size.height)/2
		var mouse_dir = get_viewport().get_mouse_pos() - screen_center
		var offset = get_pos() - get_node('Camera').get_camera_pos()
		bomb_direction = mouse_dir - offset
		var bomb = bomb_scn.instance()
		bomb.set_pos(self.get_pos())
		get_parent().add_child(bomb)

func _on_Area2D_area_enter(area):
	check_death(area)

func check_damage():
	if (!damage_cooldown.get_time_left()):
		for i in hitbox_area.get_overlapping_areas():
			if (i.is_in_group('enemy_area')):
				i.get_parent().attack()
				hud.get_node('CharInfo/LifeBar').change_life(hp, -10)
				hp -= 10
				knockback(i)
				damage_cooldown.start()
				player_flickering()
	if (hp <= 0):
		damage_cooldown.stop()
		die()

func player_flickering():
	if(damage_cooldown.get_time_left()):
		if (int(damage_cooldown.get_time_left() * 10) % 2 == 0):
			sprite.set_modulate(Color(1, 1, 1, sprite_alpha))
		else:
			sprite.set_modulate(Color(1, 1, 1, 0))
		yield(get_tree(), 'fixed_frame')
		player_flickering()

func knockback(area):
	var vector = self.get_pos() - area.get_parent().get_pos()
	speed.x += .5 * ACC * vector.x
	jump_height = -1
	speed.y -= 5 * ACC - 20 * vector.y

func _check_interactable(act):
	var areas = hitbox_area.get_overlapping_areas()
	if (act == ACT.INTERACT):
		if (areas != null):
			for i in range (0, areas.size()):
				var interactable = areas[i].get_parent()
				if (interactable.get_script() == Door):
					enter_door(areas[i])
				elif (interactable.get_script() == Lever):
					lever_interact(interactable)
				elif (interactable extends preload("res://scripts/toggle_interactable.gd")):
					interactable.toggle()

func lever_interact(lever):
	lever.pull()
	if (!get_parent().is_door_moving):
		if (lever.get_name() == 'Lever1'):
			global.flags['door'][0] = not(global.flags['door'][0])
			global.flags['door'][1] = not(global.flags['door'][1])
			global.flags['door'][3] = not(global.flags['door'][3])
			global.flags['door'][4] = not(global.flags['door'][4])
			get_parent().door_interaction()
		elif (lever.get_name() == 'Lever2'):
			global.flags['door'][0] = not(global.flags['door'][0])
			global.flags['door'][4] = not(global.flags['door'][4])
			get_parent().door_interaction()
		elif (lever.get_name() == 'Lever3'):
			global.flags['door'][1] = not(global.flags['door'][1])
			global.flags['door'][2] = not(global.flags['door'][2])
			global.flags['door'][3] = not(global.flags['door'][3])
			get_parent().door_interaction()
		elif (lever.get_name() == 'Lever4'):
			global.flags['door'][0] = not(global.flags['door'][0])
			global.flags['door'][2] = not(global.flags['door'][2])
			get_parent().door_interaction()
		emit_signal('lever_interaction')

func enter_door(area):
	var door = area.get_parent()
	get_node('../..').change_map(door.scene, door.target)

func check_death(area):
	if (area.get_name() == 'Death'):
		die()

func die():
	global.death_count += 1
	get_node('../../Hud/DeathCounter').update_death_counter()
	set_fixed_process(false)
	get_node('../..').reload_map()
