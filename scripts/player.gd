extends 'res://scripts/body.gd'

const ACT = preload('actions.gd')

onready var input = get_node('/root/input')
onready var area = get_node('AreaDetection')
var key = Vector3(0, 0, 0)

var anim = 'idle'
var anim_new

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	input.connect('hold_direction', self, '_flip_sprite')
	area.connect('area_enter', self, '_on_Area2D_area_enter')
	area.connect('area_exit',self,'_on_Area2D_area_exit')
	sprite = get_node('PlayerSprite')
	set_fixed_process(true)

func _fixed_process(delta):
	check_camera()
	check_stealth()
	check_animation()
	check_death()

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
		acc = ACC / 2
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

func check_death():
	if (self.get_pos().y > 1000):
		get_tree().change_scene('res://resources/scenes/main.tscn')

func _on_Area2D_area_enter(area):
	if (area.get_node('../').get_name() == 'Key1'):
		key.x = 1
		area.get_node('../').queue_free()
	elif (area.get_node('../').get_name() == 'Key2'):
		key.y = 1
		area.get_node('../').queue_free()
	elif (area.get_node('../').get_name() == 'Key3'):
		key.z = 1
		area.get_node('../').queue_free()
	if (area.get_node('../').get_name() == 'Door1' and key.x == 1):
		self.set_pos(Vector2(0, 0))
	if (area.get_node('../').get_name() == 'Door2' and key.x == 1):
		self.set_pos(Vector2(2863, 523))
	if (area.get_node('../').get_name() == 'Door3' and key.z == 1):
		print('Congratulations!')
	#get_node('../TestDetection/TriggerDetection').set_color(Color(1,0,0,1))

func _on_Area2D_area_exit(area):
	pass
	#get_node('../TestDetection/TriggerDetection').set_color(Color(0,1,0,1))
