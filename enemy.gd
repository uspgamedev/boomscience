
extends RigidBody2D

var enemy_particles_scn = preload("res://enemy_particles.xscn")
var particles_scn = preload("res://particles.xscn")
var direction = 1 # right = 1, left = -1
var speed = 3
var next_tile
var ray_cast
var ray_cast2
var sprite
var player
var life = 100
var life_bar

func _ready():
	set_fixed_process(true)
	
	player = get_node("../Player")
	
	ray_cast = get_node("RayCast2D")
	ray_cast2 = get_node("RayCast2D 2")
	sprite = get_node("enemy")

	life_bar = get_node("lifebar")
	life_bar.set_max(life)

	ray_cast.add_exception(self)
	ray_cast2.add_exception(self)

func _fixed_process(delta):
	var dist = player.get_pos() - self.get_pos()
	
	if (dist.length() <= 150):
		aggressive()
	else:
		passive()
	
	if direction == 1:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
	
	life_bar.set_value(life)
	if life <= 0:
		death()
	
func bomb_collision(damage):
	life -= damage
	
func passive():
	move(speed * direction)
	
	if (ray_cast.is_colliding() or !ray_cast2.is_colliding()):
		direction *= -1
		ray_cast.set_scale(Vector2(ray_cast.get_scale().x * -1, 1))
		ray_cast2.set_pos(Vector2(ray_cast2.get_pos().x * -1, ray_cast2.get_pos().y))
	
func aggressive():
	if ((player.get_pos().x > self.get_pos().x and direction == -1) or (player.get_pos().x <= self.get_pos().x and direction == 1)):
		direction *= -1
		ray_cast2.set_pos(Vector2(ray_cast2.get_pos().x * -1, ray_cast2.get_pos().y))
	move(speed * 3 * direction)
	
func death():
	var particles = enemy_particles_scn.instance()
	get_parent().add_child(particles)
	particles.get_node("enemy_particles").set_pos(get_pos())
	queue_free()
	
func move(speed):
	apply_impulse(Vector2(0, 0), Vector2(speed, 0))
