
extends CanvasLayer

var player
var life_bar

func _ready():
	player = get_parent().get_node("Player")
	
	life_bar = get_node("lifebar")
	life_bar.set_max(player.life)
	life_bar.set_value(player.life)

	set_fixed_process(true)

func _fixed_process(delta):
	life_bar.set_value(player.life)