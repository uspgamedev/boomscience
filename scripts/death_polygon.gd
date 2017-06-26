extends Area2D

var death_collision
var stick
var high_flood
var low_flood
var no_flood

func _ready():
	stick = get_node('../Stick')
	death_collision = get_node('DeathCollision')
	high_flood = death_collision.get_pos()
	low_flood = high_flood + Vector2(0, 200)
	no_flood = low_flood + Vector2(0, 200)
	if (global.flags['flood_level'] == 'low'):
		set_low_flood()
	elif (global.flags['flood_level'] == 'high'):
		set_high_flood()
	elif (global.flags['flood_level'] == 'none'):
		set_no_flood()

func set_low_flood():
	death_collision.set_pos(low_flood)

func set_high_flood():
	for i in range (51, 57):
		stick.set_cell(i, 2, 4)
		stick.set_cell(i, 14, -1)
	death_collision.set_pos(high_flood)

func set_no_flood():
	for i in range (51, 57):
		stick.set_cell(i, 2, -1)
		stick.set_cell(i, 14, 4)
	death_collision.set_pos(no_flood)
