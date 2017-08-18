extends 'res://scripts/body.gd'

var anim = 'idle'
var anim_new
var max_speed = 100
var dir = -1
var timer = 2
var temp = 0
var shape_right
var shape_left

onready var area_detection = get_node("TriangleAreaDetection")

func _ready():
	sprite = get_node('BasicEnemySprite')
	hp = 100
	get_node('LifeBar').change_life(hp, 0)
	shape_right = area_detection.get_shape(1)
	shape_left = area_detection.get_shape(0)
	area_detection.remove_shape(1)
	set_fixed_process(true)

func _fixed_process(delta):
	check_animation()
	routine(delta)

func check_animation():
	if (!speed.x):
		anim_new = 'idle'
	else:
		anim_new = 'walk'
	if (anim != anim_new):
		anim = anim_new
		get_node('BasicEnemySprite/BasicEnemyAnimation').play(anim)

func routine(delta):
	speed.x = dir * max_speed
	temp += delta
	if (temp >= timer):
		temp = 0
		dir *= -1
		sprite.set_flip_h(max(dir, 0))
		if (area_detection.get_shape(0) == shape_left):
			area_detection.remove_shape(1)
			area_detection.set_shape(0, shape_right)
		else:
			area_detection.remove_shape(1)
			area_detection.set_shape(0, shape_left)

func take_damage(damage):
	get_node('LifeBar').change_life(hp, -damage)
	hp -= damage
	if (hp <= 0):
		die()

func die():
	self.queue_free()

func _on_TriangleAreaDetection_area_enter(area):
	if (area.get_name() == "PlayerAreaDetection"):
		pass

func _on_TriangleAreaDetection_area_exit(area):
	if (area.get_name() == "PlayerAreaDetection"):
		pass

func _on_CircleAreaDetection_area_enter(area):
	if (area.get_name() == "PlayerAreaDetection"):
		pass

func _on_CircleAreaDetection_area_exit(area):
	if (area.get_name() == "PlayerAreaDetection"):
		pass
