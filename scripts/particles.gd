extends Particles2D

var timer = 0
var limit = 11

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	timer += 1
	if (timer >= limit):
		self.queue_free()

func _on_Area2D_body_enter(body):
	if (body.is_in_group('breakable_block')):
		body.queue_free()
	