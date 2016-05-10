
extends RigidBody2D

func _on_RigidBody2D_body_enter(body):
	if (body.is_in_group("enemy")):
		body.bomb_collision()
