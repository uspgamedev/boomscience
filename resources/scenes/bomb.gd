extends KinematicBody2D

const G = 1000
onready var player = get_parent().get_node('Player')
onready var particles_scn = preload('../scenes/bomb_particles.tscn')
var rotation
var cur_rotation

var speed = Vector2()

func _ready():
	adjust_speed()
	rotation = randf() - randf()
	cur_rotation = rotation
	set_fixed_process(true)

func _fixed_process(delta):
	apply_gravity(delta)
	apply_speed(delta)
	apply_rotation(delta)

func adjust_speed():
	speed = player.bomb_direction
	speed = min (500, 5 * speed.length()) * speed.normalized()
	speed += player.speed / 3

func apply_gravity(delta):
	speed.y += delta * G

func apply_speed(delta):
	var motion = move(self.speed * delta)
	if (is_colliding()):
		var particles = particles_scn.instance()
		get_parent().add_child(particles)
		particles.set_pos(get_pos())
		self.queue_free()

func apply_rotation(delta):
	cur_rotation += rotation * .3
	set_rot(cur_rotation)
