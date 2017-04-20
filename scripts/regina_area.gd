extends Area2D

func _on_Area_area_enter(area):
	var player = area.get_parent()
	if (player.get_name() == 'Player'):
		player.set_nearby_npc(self)

func _on_Area_area_exit(area):
	var player = area.get_parent()
	if (player.get_name() == 'Player'):
		player.set_nearby_npc(null)
