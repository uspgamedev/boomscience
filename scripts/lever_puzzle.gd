extends TileMap

onready var global = get_node('/root/global')

func _ready():
	door_interaction()

func door_interaction():
	for j in range (0, 5):
		if (global.flags['door'][j] == global.OPEN):
			for i in range (-2, 2):
				set_cell(20 + 2*j, i, -1)
		elif (global.flags['door'][j] == global.CLOSED):
			for i in range (-2, 2):
				set_cell(20 + 2*j, i, 14)
