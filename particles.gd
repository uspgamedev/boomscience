
extends Particles2D

var timer = 0
var limit = 8

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	timer += 1
	if(timer >= limit):
		queue_free()
	