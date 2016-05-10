
extends Node

var level_scn = preload("res://boomscience.xscn")
var current_level

func _ready():
	current_level = level_scn.instance()
	add_child(current_level)

	set_process_input(true)

func _input(event):
	if (event.is_action("ui_cancel") and !event.is_pressed()):
		print("xablau")
		var screen_size = OS.get_window_size()
		var bg = get_node("CanvasLayer/pause_bg")
		if (!get_tree().is_paused()):
			print("pausou")
			get_tree().set_pause(true)
			current_level.set_fixed_process(false)
			bg.set_scale( screen_size / Vector2( 800, 600 ) )
			bg.show()
		else:
			print("DESpausou")
			get_tree().set_pause(false)
			current_level.set_fixed_process(true)
			bg.hide()