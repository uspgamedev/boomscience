extends CanvasLayer

onready var dialog_reader = get_node('DialogReader')

func is_dialog_reader_hidden():
	return dialog_reader.is_hidden()

func hide_dialog_reader():
	dialog_reader.hide()

func show_dialog_reader():
	dialog_reader.show()
