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
onready var wall_collider = null
onready var pit = Vector2(0, 0)
onready var player = null
onready var detected = false

onready var area_detection = get_node("AreaDetection")
onready var enemy_area = get_node('BasicEnemyArea')
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
	for i in enemy_area.get_overlapping_areas():
		if (i.is_in_group('smoke_particles')):
			print('in smoke')
	check_detection(delta)
	check_walls()
	check_pits()

func check_pits():
	var space_state = get_world_2d().get_direct_space_state()
	var result_left = space_state.intersect_ray(self.get_pos() + Vector2(-20, 0), \
	                  self.get_pos() + Vector2(-20, 30), [self])
	var result_right = space_state.intersect_ray(self.get_pos() + Vector2(20, 0), \
	                   self.get_pos() + Vector2(20, 30), [self])
	if ((pit.x == 0 and result_left.empty()) or (pit.y == 0 and result_right.empty())):
		temp = timer
	if (!result_left.empty()):
		pit.x = 0
	else:
		pit.x = 1
	if (!result_right.empty()):
		pit.y = 0
	else:
		pit.y = 1
	return pit

func check_walls():
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(self.get_pos() + Vector2(20, 0), \
			self.get_pos() + Vector2(-20, 0), [self])
	if (!result.empty()):
		if (result.collider != wall_collider and result.collider extends TileMap):
			wall_collider = result.collider
			temp = timer
		return result
	else:
		wall_collider = null
		return null

func change_animation(animation):
	if (attack_timer.get_time_left() == 0):
		anim_new = animation
		if (anim != anim_new):
			anim = anim_new
			enemy_animation.play(anim)

func run():
	change_animation('run')
	speed.x = dir * max_speed

func stop():
	change_animation('idle')
	speed.x = 0

func walk():
	change_animation('walk')
	speed.x = dir * max_speed/2

func check_detection(delta):
	temp += delta
	if (!detected):
		passive()
	else:
		aggressive()

func aggressive():
	var vector = player.get_pos() - self.get_pos()
	var result_walls = check_walls()
	var result_pits = check_pits()
	if (result_walls != null):
		if ((result_walls.position.x < self.get_pos().x and vector.x >= 0) or \
		    (result_walls.position.x >= self.get_pos().x and vector.x < 0)):
			run()
		elif(result_walls.collider extends TileMap):
			stop()
		else:
			run()
	elif (result_pits != Vector2(0, 0)):
		if ((result_pits.x and vector.x >= 0) or \
		    (result_pits.y and vector.x < 0)):
			run()
		else:
			stop()
	elif (attack_timer.get_time_left() == 0 and wall_collider == null):
		run()
	elif (temp >= timer and temp < 2*timer):
		stop()
	if (vector.x > 10):
		change_dir(1)
		flip_vision(shape_right)
	elif (vector.x < -10):
		change_dir(-1)
		flip_vision(shape_left)
	elif (vector.y < 10):
		stop()
	sprite.set_flip_h(max(dir, 0))

func change_dir(direction):
	if (attack_timer.get_time_left() == 0):
		dir = direction

func passive():
	if (temp < timer):
		walk()
	elif (temp >= timer and temp < 2*timer):
		stop()
	else:
		temp = 0
		change_dir(-dir)
		sprite.set_flip_h(max(dir, 0))
		check_vision()

func flip_vision(shape):
	if (attack_timer.get_time_left() == 0):
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
	if (area.is_in_group('player_area')):
		player = area.get_parent()
		detected = true

func _on_AreaDetection_area_exit(area):
	if (area.is_in_group('player_area')):
		detected = false

# This method is called in player.gd
func attack():
	speed.x = 0
	change_animation('attack')
	attack_timer.start()
