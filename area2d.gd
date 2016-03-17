
extends Area2D

func _ready():
	self.add_to_group("bomb_particles")
	#get_node(self).connect("body_enter", , "_on_Area2D_body_enter")
	#connect("body_enter", self, "_on_Area2D_body_enter")
	pass
	
func _on_Area2D_body_enter(body):
	print("body_enter")
	if(body.is_in_group("enemies")):
		body.bomb_collision()
