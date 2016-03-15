
extends Particles2D

var timer = 0
var limit = 10

func _ready():
	set_fixed_process(true)
	self.add_to_group("bomb_particles")

func _fixed_process(delta):
	timer += 1
	if(timer >= limit):
		queue_free()
	