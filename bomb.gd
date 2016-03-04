
extends RigidBody2D

var particles_scn = preload("res://particles.xscn")

func _ready():
	pass

func _on_bomb_body_enter(body):
	if(body.is_in_group("floor")):
		var particles = particles_scn.instance()
		get_parent().add_child(particles)
		particles.get_node("particles").set_pos(self.get_pos())
		queue_free()
