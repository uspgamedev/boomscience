
extends RigidBody2D

func _ready():
	pass

func _on_bomb_body_enter(body):
	if(body.is_in_group("floor")):
		queue_free()
