
extends Sprite

var damage = 10

func _ready():
	pass


func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemies") or body.get_name() == "Player":
		body.death()