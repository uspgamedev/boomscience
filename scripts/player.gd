extends 'res://scripts/body.gd'

const Door = preload("res://scripts/door.gd")

const ACT = preload('actions.gd')
var bombs = [
	preload('../resources/scenes/bomb.tscn'),
	preload('../resources/scenes/projectiles/gem_bomb.tscn')
]
var bomb_scn = null

onready var input = get_node('/root/input')
onready var global = get_node('/root/global')
onready var area = get_node('PlayerAreaDetection')
onready var fx = get_node('SamplePlayer')
onready var hud = get_node('../../Hud')
onready var invslot_view = hud.get_node('CharInfo/InventorySlot')
var key = [0, 0, 0, 0]

var anim = 'idle'
var anim_new
var bomb_cooldown = 0
var bomb_direction
var nearby_npc
var equipped_bomb = 0
var climbing = false

signal equipped_bomb(texture)

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('press_action', self, '_interact')
	input.connect('press_bomb_throw', self, '_bomb_throw')
	input.connect('press_action', self, '_switch_bomb')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	input.connect('hold_direction', self, '_flip_sprite')
	area.connect('area_enter', self, '_on_Area2D_area_enter')
	area.connect('area_exit',self,'_on_Area2D_area_exit')
	self.connect('equipped_bomb', invslot_view, '_change_icon')
	hp = 500
	equip_bomb(0)
	var lifebar = hud.get_node('CharInfo/LifeBar')
	lifebar.set_max(500)
	lifebar.change_life(hp, 0)
	sprite = get_node('PlayerSprite')
	get_node('Congratulations').hide()
	speed = Vector2(0, 0)

func _fixed_process(delta):
	check_camera()
	check_stealth()
	check_animation()
	check_stairs()
	update_bomb_cooldown()

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

func check_stairs():
	var stairs = get_node('../Stairs')
	var anim = get_node('PlayerSprite/PlayerAnimation')
	var act = input._get_action(Input)
	var dir = input._get_direction(Input)
	if (stairs.get_cellv(stairs.world_to_map(self.get_pos())) != -1 and (dir != -1 and dir != DIR.RIGHT and dir != DIR.LEFT)):
		climbing = true
		align_stair_axis()
	if (stairs.get_cellv(stairs.world_to_map(self.get_pos())) == -1 or act == ACT.JUMP or dir == DIR.RIGHT or dir == DIR.LEFT):
		climbing = false
		G = 3000
		if (act != ACT.STEALTH):
			acc = ACC
	elif (climbing):
		G = 0
		acc = .4 * acc
		if (act != ACT.CAMERA):
			if (dir == DIR.UP or dir == DIR.UP_RIGHT or dir == DIR.UP_LEFT):
				speed.y -= 20
				if (!anim.is_playing()):
					anim.play('climb')
			elif (dir == DIR.DOWN or dir == DIR.DOWN_RIGHT or dir == DIR.DOWN_LEFT):
				speed.y += 20
				if (!anim.is_playing()):
					anim.play('climb')
			else:
				speed.y = 0
				anim.stop()

func align_stair_axis():
	var stairs = get_node('../Stairs')
	var stair_pos = stairs.map_to_world(stairs.world_to_map(self.get_pos()))
	var stair_width = stairs.get_cell_size().x
	self.set_pos(Vector2(stair_pos.x + stair_width/2, self.get_pos().y))

func player_freeze():
	if (input.is_connected('hold_direction', self, '_add_speed')):
		input.disconnect('hold_direction', self, '_add_speed')
	if (input.is_connected('press_action', self, '_jump')):
		input.disconnect('press_action', self, '_jump')
	if (input.is_connected('press_bomb_throw', self, '_bomb_throw')):
		input.disconnect('press_bomb_throw', self, '_bomb_throw')

func player_unfreeze():
	if (!input.is_connected('hold_direction', self, '_add_speed')):
		input.connect('hold_direction', self, '_add_speed')
	if (!input.is_connected('press_action', self, '_jump')):
		input.connect('press_action', self, '_jump')
	if (!input.is_connected('press_bomb_throw', self, '_bomb_throw')):
		input.connect('press_bomb_throw', self, '_bomb_throw')

func check_camera():
	var act = input._get_action(Input)
	if (act == ACT.CAMERA):
		player_freeze()
	elif (act == -1 and hud.is_dialog_reader_hidden()):
		player_unfreeze()

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
	elif (climbing):
		anim_new = 'climb'
	elif (!can_jump):
		anim_new = 'jump'
	elif (speed.x):
		anim_new = 'walk'
	if (anim != anim_new):
		anim = anim_new
		get_node('PlayerSprite/PlayerAnimation').play(anim)

func update_bomb_cooldown():
	if (bomb_cooldown >= 1):
		bomb_cooldown += 1
		if (bomb_cooldown > 20):
			bomb_cooldown = 0

func _bomb_throw(throw):
	if (bomb_cooldown == 0):
		if (throw == ACT.THROW):
			bomb_cooldown = 1
			var screen_center = Vector2(get_viewport_rect().size.width, get_viewport_rect().size.height)/2
			var mouse_dir = get_viewport().get_mouse_pos() - screen_center
			var offset = get_pos() - get_node('Camera').get_camera_pos()
			bomb_direction = mouse_dir - offset
			var bomb = bomb_scn.instance()
			bomb.set_pos(self.get_pos())
			get_parent().add_child(bomb)

func _on_Area2D_area_enter(area):
	check_keys(area)
	check_doors(area)
	check_death(area)
	check_damage(area)

func check_damage(area):
	var area_node = area.get_node('../')
	if (area_node.is_in_group('enemy')):
		hud.get_node('CharInfo/LifeBar').change_life(hp, -100)
		hp -= 100
		knockback(area_node)
	if (hp <= 0):
		die()

func knockback(area_node):
	var vector = self.get_pos() - area_node.get_pos()
	speed.x += .5 * ACC * vector.x
	speed.y -= 5 * ACC - 20 * vector.y

func check_keys(area):
	check_key_name(area, 'Key1', 0)
	check_key_name(area, 'Key2', 1)

func check_key_name(area, key_name, key_index):
	if (area.get_node('../').get_name() == key_name):
		key[key_index] = 1
		fx.play_confirmation()
		area.get_node('../').queue_free()

func check_doors(area):
	var door = area.get_parent()
	if ((global.stage == 0 and key[0] == 1) or \
		(global.stage == 1 and key[1] == 1)):
		if (door.get_script() == Door):
			if (global.stage == 0):
				fx.play('confirmation')
				global.stage += 1
				self.set_pos(global.respawn)
				get_node('../..').reload_map()
			elif (global.stage == 1):
				if (get_node('Congratulations').is_hidden()):
					fx.play('confirmation')
				global.stop_chronometer()
				get_node('Congratulations').show()

func check_death(area):
	if (area.get_name() == 'Death'):
		die()

func die():
	global.death_count += 1
	get_node('../../Hud/DeathCounter').update_death_counter()
	set_fixed_process(false)
	get_node('../..').reload_map()
