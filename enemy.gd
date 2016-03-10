
extends RigidBody2D

var particles_scn = preload("res://enemy_particles.xscn")

func _ready():
	self.add_to_group("enemies")

func _on_RigidBody2D_body_enter(body):
	if(body.is_in_group("bombs")):
		var particles = particles_scn.instance()
		get_parent().add_child(particles)
		particles.get_node("enemy_particles").set_pos(self.get_pos())
		queue_free()
	