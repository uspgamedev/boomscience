
extends CanvasLayer

var player
var life_bar

var cd_max = [0.5, 3, 0.1, 10]
var cd_bar = [0, 0, 0, 0]

func _ready():
	player = get_parent().get_node("Player")
	
	life_bar = get_node("lifebar")
	life_bar.set_max(player.life)
	life_bar.set_value(player.life)

	for i in range(0,4):
		cd_bar[i] = get_node("bomb_cd" + str(i))
		cd_bar[i].set_max(cd_max[i])
		cd_bar[i].set_value(cd_max[i])
		cd_bar[i].hide()

	set_fixed_process(true)

func _fixed_process(delta):
	life_bar.set_value(player.life)

	for i in range(0, 4):
		cd_bar[i].set_value(player.cd_count[i])
		if cd_bar[i].get_value() >= cd_max[i]:
			cd_bar[i].hide()
		else:
			cd_bar[i].show()