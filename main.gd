
extends Node

var level1_scn = preload("res://boomscience.xscn")
var level2_scn = preload("res://level2.xscn")
var current_level
var player = preload("res://player.xscn")

func _ready():
	current_level = level1_scn.instance()
	add_child(current_level)

	player = player.instance()
	current_level.add_child(player)

	set_process_input(true)

func _input(event):
	if (event.is_action("ui_cancel") and !event.is_pressed()):
		var screen_size = OS.get_window_size()
		var bg = get_node("CanvasLayer/pause_bg")
		if (!get_tree().is_paused()):
			get_tree().set_pause(true)
			current_level.set_fixed_process(false)
			bg.set_scale(screen_size/Vector2(800, 600))
			bg.show()
		else:
			get_tree().set_pause(false)
			current_level.set_fixed_process(true)
			bg.hide()
	
	elif (event.is_action("change")):
		change_scene()

func change_scene():
	current_level.queue_free()

	
	current_level = level2_scn.instance()
	add_child(current_level)
	player = preload("res://player.xscn")
	player = player.instance()
	player.set_pos(current_level.player_pos)
	current_level.add_child(player)