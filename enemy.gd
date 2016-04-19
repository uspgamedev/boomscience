
extends RigidBody2D

var enemy_particles_scn = preload("res://enemy_particles.xscn")
var particles_scn = preload("res://particles.xscn")
var direction = 1 # right = 1, left = -1
var speed = 30
var count = 0
var max_count = 5
var next_tile
var ray_cast
var ray_cast2
var sprite

var life = 100
var life_bar

func _ready():
	set_fixed_process(true)
	ray_cast = get_node("RayCast2D")
	ray_cast2 = get_node("RayCast2D 2")
	sprite = get_node("enemy")

	life_bar = get_node("lifebar")
	life_bar.set_max(life)

	ray_cast.add_exception(self)
	ray_cast2.add_exception(self)

func _fixed_process(delta):
	if direction == 1:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
		
	count += delta
	if (count >= max_count):
		direction *= -1
		ray_cast.set_scale(Vector2(ray_cast.get_scale().x * -1, 1))
		count = 0
	move(speed * direction, 5, delta)

	if (ray_cast.is_colliding() or !ray_cast2.is_colliding() ):
		direction *= -1
		ray_cast.set_scale(Vector2(ray_cast.get_scale().x * -1, 1))
		ray_cast2.set_pos(Vector2(ray_cast2.get_pos().x * -1, ray_cast2.get_pos().y))
		count = 0

	life_bar.set_value(life)
	if life <= 0:
		death()

func death():
	var particles = enemy_particles_scn.instance()
	get_parent().add_child(particles)
	particles.get_node("enemy_particles").set_pos(get_pos())
	queue_free()

func bomb_collision(damage):
	life -= damage

func move(speed, acceleration, delta):
	var current_speed_x = get_linear_velocity().x
	current_speed_x = lerp(current_speed_x, speed, acceleration * delta)
	set_linear_velocity(Vector2(current_speed_x, get_linear_velocity().y))