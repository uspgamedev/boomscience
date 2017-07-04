extends "res://scripts/toggle_interactable.gd"

onready var sprite = get_node("Sprite")

func _ready():
	if toggled():
		sprite.set_rotd(-90)

func _interact(state):
	if toggled():
		sprite.set_rotd(-90)
	else:
		sprite.set_rotd(0)
