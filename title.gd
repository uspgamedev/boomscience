
extends Panel


func _ready():
	get_node("/root/global").current_scene = self

	set_fixed_process(true)

#func _fixed_process(delta):
#	var window_size = OS.get_window_size()
#	set_size(window_size)
#	get_node("TitleBackground").set_size(window_size)
#	get_node("MainMenu").set_size(window_size)


func _on_Play_pressed():
	get_node("/root/global").goto_scene("res://main.xscn")


func _on_Settings_pressed():
	pass # replace with function body

func _on_Quit_pressed():
	get_tree().quit()