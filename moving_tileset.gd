
extends TileMap

var count = 0
var max_count = 3
var direction = 1 #1 = right, -1 = left

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	count += delta
	set_pos(Vector2(get_pos().x + 2 * direction, 0))
	if (count >= max_count):
		direction *= -1
		count = 0
	