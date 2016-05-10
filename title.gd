
extends Panel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("/root/global").current_scene = self
	pass


func _on_Play_pressed():
	get_node("/root/global").goto_scene("res://boomscience.xscn")


func _on_Settings_pressed():
	pass # replace with function body

func _on_Quit_pressed():
	get_tree().quit()