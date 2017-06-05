extends Node

var respawn = Vector2(0, 0)
var stage
var death_count
var chronometer
var minute
var second
const STAGES = [
	preload('res://resources/scenes/stage01.tscn'),
	preload('res://resources/scenes/stage02.tscn')
]
const RESPAWN = [
	Vector2(5000, 200), 
	Vector2(0, 0)
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
	respawn = Vector2(0, 0)
	stage = 0
	death_count = 1
	chronometer = 0
	minute = 0
	second = 0

func get_current_stage():
	return STAGES[stage]
