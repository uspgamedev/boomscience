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
		var pos = self.get_pos()
		var exp_tile = body.world_to_map(pos)
		for i in range(-2, 2):
			for j in range(-2, 2):
				var tile = exp_tile + Vector2(i, j)
				if ((body.map_to_world(tile) - pos).length() < 80):
					body.set_cellv(tile, -1)
	if (body.is_in_group('enemy')):
		body.take_damage(40)
