
extends Particles2D

var timer = 0
var limit = 10

var damage = 20

func _ready():
	add_to_group("bomb_particles")
	set_fixed_process(true)

func _fixed_process(delta):
	timer += 1
	if(timer >= limit):
		queue_free()

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemies"):
		body.bomb_collision()
	