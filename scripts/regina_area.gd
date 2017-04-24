extends Area2D

onready var sprite = get_parent()
onready var player = get_node('../../Player')

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	check_sprite_flip()

func check_sprite_flip():
	if (player.get_pos().x < sprite.get_pos().x):
		sprite.set_flip_h(false)
	else:
		sprite.set_flip_h(true)

func _on_Area_area_enter(area):
	var player = area.get_parent()
	if (player.get_name() == 'Player'):
		player.set_nearby_npc(self)

func _on_Area_area_exit(area):
	var player = area.get_parent()
	if (player.get_name() == 'Player'):
		player.set_nearby_npc(null)
