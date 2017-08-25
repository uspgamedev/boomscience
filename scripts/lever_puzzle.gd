extends TileMap

const EMPTY = -1
const DOOR = 52

var is_door_moving = false

onready var global = get_node('/root/global')
onready var gates = get_node('Gates')

func _ready():
	door_interaction()

func door_interaction():
	is_door_moving = true
	for i in range (-3, 3):
		for k in range (0, 5):
			yield(get_tree(), 'fixed_frame')
		for j in range (0, 5):
			if (global.flags['door'][j] == global.OPEN):
				gates.set_cell(20 + 2*j, -i-1, EMPTY)
			elif (global.flags['door'][j] == global.CLOSED):
				gates.set_cell(20 + 2*j, i, DOOR)
	is_door_moving = false
