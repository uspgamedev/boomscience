extends Node

const ENTRANCE = 0
const WATER_PUZZLE = 1
const VALVE_ROOM = 2
const LEVER_PUZZLE = 3

var stage
var death_count
var chronometer
var minute
var second
var flags
const STAGES = [
	preload('res://resources/scenes/sewers/entrance.tscn'),
	preload('res://resources/scenes/sewers/water-puzzle.tscn'),
	preload('res://resources/scenes/sewers/valve_room.tscn'),
	preload('res://resources/scenes/sewers/lever_puzzle.tscn'),
]
const RESPAWN = [
	Vector2(-800, -600), 
	Vector2(0, 0), 
	Vector2(0, 0), 
	Vector2(0, 0), 
]

func _ready():
	init()
	set_fixed_process(true)

func _fixed_process(delta):
	check_chronometer(delta)

func stop_chronometer():
	set_fixed_process(false)

func check_chronometer(delta):
	chronometer += delta
	if (chronometer >= 1):
		second += 1
		chronometer -= 1
	if (second >= 60):
		minute += 1
		second = 0

func reset():
	init()
	set_fixed_process(true)

func init():
	stage = WATER_PUZZLE
	death_count = 1
	chronometer = 0
	minute = 0
	second = 0
	flags = {}
	flags['flood_level'] = 'low'

func get_current_stage():
	return STAGES[stage]

func get_current_stage_respawn():
	return RESPAWN[stage]
