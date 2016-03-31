
extends RigidBody2D

var enemy_particles_scn = preload("res://enemy_particles.xscn")
var particles_scn = preload("res://particles.xscn")
var direction = 1 # right = 1, left = -1
var speed = 30
var count = 0
var max_count = 5
var next_tile
var ray_cast
var sprite

func _ready():
	#get_node("../ParticlesRoot/Area2D").connect("body_enter", self, "_on_Area2D_body_enter")
	self.add_to_group("enemies")
	set_fixed_process(true)
	ray_cast = get_node("RayCast2D")
	sprite = get_node("enemy")
	ray_cast.add_exception(self)

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
	set_pos(get_pos() + Vector2(direction * speed*delta, 0))
	if (ray_cast.is_colliding()):
		direction *= -1
		ray_cast.set_scale(Vector2(ray_cast.get_scale().x * -1, 1))
		count = 0

func bomb_collision():
	var particles = enemy_particles_scn.instance()
	get_parent().add_child(particles)
	particles.get_node("enemy_particles").set_pos(get_pos())
	queue_free()
	