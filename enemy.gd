
extends RigidBody2D

var enemy_particles_scn = preload("res://enemy_particles.xscn")
var particles_scn = preload("res://particles.xscn")

func _ready():
	#get_node("../ParticlesRoot/Area2D").connect("body_enter", self, "_on_Area2D_body_enter")
	self.add_to_group("enemies")

func bomb_collision():
	print ("oi")
	var particles = enemy_particles_scn.instance()
	get_parent().add_child(particles)
	particles.get_node("enemy_particles").set_pos(self.get_pos())
	queue_free()
	
func _on_Area2D_body_enter(body):
	print("body_enter")
	if(body.is_in_group("enemies")):
		body.bomb_collision()
	