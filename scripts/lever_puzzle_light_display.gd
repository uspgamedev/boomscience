extends Node2D

onready var player = get_node('../Player')
onready var global = get_node('/root/global')

func _ready():
	player.connect('lever_interaction', self, '_update_light')
	_update_light()

func _update_light():
	for i in range (0, 5):
		if (global.flags['door'][i] == global.OPEN):
			get_child(i).change_to_green()
		elif (global.flags['door'][i] == global.CLOSED):
			get_child(i).change_to_red()
