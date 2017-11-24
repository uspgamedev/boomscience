extends "res://scripts/bomb.gd"

func _ready():
	particles_scn = preload('../../resources/scenes/smoke_particles.tscn')
	set_fixed_process(true)

func _fixed_process(delta):
	if (is_colliding()):
		var particles = particles_scn.instance()
		get_parent().add_child(particles)
		particles.set_pos(get_pos())
		particles.get_node('ActiveTimer').start()
		self.queue_free()