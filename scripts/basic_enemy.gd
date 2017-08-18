extends 'res://scripts/body.gd'

var anim = 'idle'
var anim_new
var max_speed = 200
var dir = -1
var timer = 2
var temp = 0
var shape_right
var shape_left
var circle_shape
onready var player = null
onready var detected = false

onready var area_detection = get_node("AreaDetection")

func _ready():
	sprite = get_node('BasicEnemySprite')
	hp = 100
	get_node('LifeBar').change_life(hp, 0)
	shape_left = area_detection.get_shape(0)
	shape_right = area_detection.get_shape(1)
	circle_shape = area_detection.get_shape(2)
	area_detection.remove_shape(1)
	set_fixed_process(true)

func _fixed_process(delta):
	check_animation()
	check_detection(delta)

func check_detection(delta):
	print(detected)
	if (!detected):
		passive(delta)
	else:
		aggressive(delta)

func check_animation():
	if (!speed.x):
		anim_new = 'idle'
	else:
		anim_new = 'walk'
	if (anim != anim_new):
		anim = anim_new
		get_node('BasicEnemySprite/BasicEnemyAnimation').play(anim)

func aggressive(delta):
	var vector = player.get_pos() - self.get_pos()
	if (vector.x > 0):
		dir = 1
	else:
		dir = -1
	sprite.set_flip_h(max(dir, 0))
	speed.x = dir * max_speed

func passive(delta):
	speed.x = dir * max_speed/2
	temp += delta
	if (temp >= timer):
		temp = 0
		dir *= -1
		sprite.set_flip_h(max(dir, 0))
		check_vision()

func check_vision():
	if (area_detection.get_shape(0) == shape_left):
		if (area_detection.get_shape(1) != circle_shape):
			area_detection.remove_shape(1)
		if (area_detection.get_shape(2) != circle_shape):
			area_detection.remove_shape(2)
		
		area_detection.set_shape(0, shape_right)
	else:
		if (area_detection.get_shape(1) != circle_shape):
			area_detection.remove_shape(1)
		if (area_detection.get_shape(2) != circle_shape):
			area_detection.remove_shape(2)
		area_detection.set_shape(0, shape_left)

func take_damage(damage):
	get_node('LifeBar').change_life(hp, -damage)
	hp -= damage
	if (hp <= 0):
		die()

func die():
	self.queue_free()

func _on_AreaDetection_area_enter(area):
	if (area.get_name() == "PlayerAreaDetection"):
		player = area.get_parent()
		detected = true

func _on_AreaDetection_area_exit(area):
	if (area.get_name() == "PlayerAreaDetection"):
		detected = false
