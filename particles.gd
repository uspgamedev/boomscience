
extends Particles2D

var timer = 0
var limit = 10

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	timer += 1
	if(timer >= limit):
		queue_free()
		get_node("../RigidBody2D").queue_free()
	