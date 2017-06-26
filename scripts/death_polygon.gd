extends Area2D

var death_collision
var high_flood
var low_flood
var no_flood

func _ready():
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
	death_collision.set_pos(high_flood)

func set_no_flood():
	death_collision.set_pos(no_flood)
