extends 'res://scripts/body.gd'

const ACT = preload('actions.gd')

onready var input = get_node('/root/input')
onready var area = get_node('AreaDetection')

func _ready():
	set_fixed_process(true)
	input.connect('press_action', self, '_jump')
	input.connect('hold_action', self, '_add_jump_height')
	input.connect('hold_direction', self, '_add_speed')
	area.connect('area_enter', self, '_on_Area2D_area_enter')
	area.connect('area_exit',self,'_on_Area2D_area_exit')
	set_fixed_process(true)

func _fixed_process(delta):
	check_camera()
	check_stealth()

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
	var player_sprite = get_node('PlayerSprite')
	if (act == ACT.STEALTH):
		area.set_scale(Vector2(.3, .3))
		player_sprite.set_modulate(Color(1, 1, 1, .5))
		acc = 100
	else:
		area.set_scale(Vector2(1, 1))
		player_sprite.set_modulate(Color(1, 1, 1, 1))
		acc = 200

func _on_Area2D_area_enter(area):
	get_node('../TestDetection/TriggerDetection').set_color(Color(1,0,0,1))

func _on_Area2D_area_exit(area):
	get_node('../TestDetection/TriggerDetection').set_color(Color(0,1,0,1))
	