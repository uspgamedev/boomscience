
extends Node

func _input(event):
	if (event.is_action("ui_cancel") and !event.is_pressed()):
		var screen_size = OS.get_window_size()
		var menu = get_node("Canvas/pause_menu")
		var bg = get_node("Canvas/pause_bg")
		if (!get_tree().is_paused()):
			get_tree().set_pause(true)
			current_level.set_fixed_process(false)
			bg.set_scale( screen_size / Vector2( 800, 600 ) )
			bg.show()
			menu.show()
		else:
			get_tree().set_pause(false)
			current_level.set_fixed_process(true)
			bg.hide()
			menu.hide()