
extends RigidBody2D

var particles_scn = preload("res://particles.xscn")
var vel_limit = 450

func _ready():
	self.add_to_group("bombs")
	if abs(get_linear_velocity().x) >= vel_limit:
		if get_linear_velocity().x >= 0:
			set_linear_velocity( Vector2( vel_limit, get_linear_velocity().y))
		else:
			set_linear_velocity( Vector2( -vel_limit, get_linear_velocity().y))

func _on_bomb_body_enter(body):
	if(body.is_in_group("floor") or body.is_in_group("enemies")):
		var particles = particles_scn.instance()
		get_parent().add_child(particles)
		particles.set_pos(get_pos())
		queue_free()
	