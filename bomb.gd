
extends RigidBody2D

var particles_scn = preload("res://particles.xscn")
var smoke_particles_scn = preload("res://smoke_particles.xscn")
var vel_limit = 450
var character_path

func _ready():
	self.add_to_group("bombs")
	if abs(get_linear_velocity().x) >= vel_limit:
		if get_linear_velocity().x >= 0:
			set_linear_velocity( Vector2( vel_limit, get_linear_velocity().y))
		else:
			set_linear_velocity( Vector2( -vel_limit, get_linear_velocity().y))
	character_path = get_parent().get_node("Player")

	if (character_path.bomb_value() == 2):
		get_node("bomb").set_modulate(Color(.7, .3, .3))
	elif (character_path.bomb_value() == 3):
		get_node("bomb").set_modulate(Color(.5, .75, .8))
	elif (character_path.bomb_value() == 4):
		get_node("bomb").set_modulate(Color(.2, .2, 1))
	elif (character_path.bomb_value() == 5):
		get_node("bomb").set_modulate(Color(.5, .5, .5))
		
func _on_bomb_body_enter(body):
	if(body.is_in_group("floor") or body.is_in_group("enemies")):
		if (character_path.bomb_value() == 5):
			var particles = smoke_particles_scn.instance()
			get_parent().add_child(particles)
			particles.get_node("particles").set_pos(get_pos())
			particles.get_node("particles2").set_pos(get_pos())
			queue_free()
		else:
			var particles = particles_scn.instance()
			get_parent().add_child(particles)
			particles.set_color_phase_color(0, get_node("bomb").get_modulate())
			particles.set_pos(get_pos())
			queue_free()
	
