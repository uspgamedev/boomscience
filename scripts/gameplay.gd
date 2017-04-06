
extends Node

const ACT = preload('actions.gd')
const DIR = preload('directions.gd')
const PLAYER = preload ('res://resources/scenes/player.tscn')

onready var input = get_node('/root/input')
var player

func _ready():
	input.connect('press_quit', self, 'quit')
	input.connect('press_reset', self, 'reset')
	input.connect('press_respawn', self, 'respawn')
	player = PLAYER.instance()
	reload_map()
	set_fixed_process(true)

func reset():
	global.reset()
	reload_map()

func respawn():
	global.death_count += 1
	get_node('Hud/DeathCounter').update_death_counter()
	reload_map()

func reload_map():
	var current_stage = get_node('Stage')
	if (current_stage != null):
		current_stage.remove_child(player)
		current_stage.queue_free()
		yield(get_tree(), 'fixed_frame')
		yield(get_tree(), 'fixed_frame')
	var tmp = global.get_current_stage().instance()
	tmp.set_name('Stage')
	player.set_pos(global.respawn)
	tmp.add_child(player)
	self.add_child(tmp)
 
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
