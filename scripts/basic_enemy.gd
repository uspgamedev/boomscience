extends 'res://scripts/body.gd'

var anim
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
onready var enemy_animation = get_node('BasicEnemySprite/BasicEnemyAnimation')
onready var attack_timer = get_node('AttackTimer')

func _ready():
	sprite = get_node('BasicEnemySprite')
	hp = 100
	get_node('LifeBar').change_life(hp, 0)
	shape_left = area_detection.get_shape(0)
	shape_right = area_detection.get_shape(1)
	circle_shape = area_detection.get_shape(2)
	area_detection.remove_shape(1)
	change_animation('idle')
	set_fixed_process(true)

func _fixed_process(delta):
	check_detection(delta)

func check_detection(delta):
	if (!detected):
		passive(delta)
	else:
		aggressive(delta)

func change_animation(animation):
	if (attack_timer.get_time_left() == 0):
		anim_new = animation
		if (anim != anim_new):
			anim = anim_new
			enemy_animation.play(anim)

func aggressive(delta):
	var vector = player.get_pos() - self.get_pos()
	change_animation('run')
	temp = 0
	if (attack_timer.get_time_left() == 0):
		speed.x = dir * max_speed
	if (vector.x > 10):
		dir = 1
		flip_vision(shape_right)
	elif (vector.x < -10):
		dir = -1
		flip_vision(shape_left)
	else:
		change_animation('idle')
		speed.x = 0
	sprite.set_flip_h(max(dir, 0))

func passive(delta):
	change_animation('walk')
	speed.x = dir * max_speed/2
	temp += delta
	if (temp >= timer):
		change_animation('idle')
		speed.x = 0
	if (temp >= 2*timer):
		speed.x = dir * max_speed/2
		temp = 0
		dir *= -1
		sprite.set_flip_h(max(dir, 0))
		check_vision()

func flip_vision(shape):
	if (area_detection.get_shape_count() > 1 and area_detection.get_shape(1) != circle_shape):
		area_detection.remove_shape(1)
	if (area_detection.get_shape_count() > 2 and area_detection.get_shape(2) != circle_shape):
		area_detection.remove_shape(2)
	area_detection.set_shape(0, shape)

func check_vision():
	if (area_detection.get_shape(0) == shape_left):
		flip_vision(shape_right)
	else:
		flip_vision(shape_left)

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

# This function is called in player.gd
func attack():
	speed.x = 0
	change_animation('attack')
	attack_timer.start()
