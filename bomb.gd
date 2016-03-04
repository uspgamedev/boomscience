
extends RigidBody2D

var timer = 0

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	timer += 1
	if(timer >= 60):
		queue_free()
