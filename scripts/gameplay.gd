
extends Node

const ACT = preload('actions.gd')
const DIR = preload('directions.gd')
const HUD = preload('res://resources/scenes/hud.tscn')

onready var player = get_node('Player')
onready var input = get_node('/root/input')

func _ready():
	input.connect('press_quit', self, 'quit')
	input.connect('press_reset', self, 'reset')
	input.connect('press_respawn', self, 'respawn')
	self.add_child(HUD.instance())
	set_fixed_process(true)

func reset():
	global.reset()
	get_tree().change_scene('res://resources/scenes/main.tscn')

func respawn():
	global.death_count += 1
	get_tree().change_scene('res://resources/scenes/main.tscn')

func quit():
	get_tree().quit()

func _fixed_process(delta):
	check_instructions()

func check_instructions():
	var hud = get_node('Hud/Instructions')
	var background = get_node('Hud/Background')
	var objective = get_node('Hud/Objective')
	var act = input._get_action(Input)
	if (act == ACT.INST):
		hud.show()
		background.show()
		objective.show()
	else:
		hud.hide()
		background.hide()
		objective.hide()
