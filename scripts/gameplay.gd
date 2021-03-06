
extends Node

const ACT = preload('actions.gd')
const DIR = preload('directions.gd')
const PLAYER = preload ('res://resources/scenes/player.tscn')

onready var input = get_node('/root/input')
onready var hud = get_node('Hud/Instructions')
onready var background = get_node('Hud/Background')
onready var objective = get_node('Hud/Objective')
onready var restart_cooldown = get_node('RestartCooldown')

var player

func _ready():
	input.connect('press_quit', self, 'quit')
	input.connect('press_action', self, 'on_press_action')
	input.connect('release_action', self, 'on_release_action')
	restart_cooldown.connect('timeout', self, 'enable_restart')
	restart_cooldown.start()
	player = PLAYER.instance()
	reload_map()

func enable_restart():
	input.connect('press_reset', self, 'reset')
	input.connect('press_respawn', self, 'respawn')

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
	player.set_pos(global.get_current_stage_respawn())
	tmp.add_child(player)
	self.add_child(tmp)
	input.disconnect('press_reset', self, 'reset')
	input.disconnect('press_respawn', self, 'respawn')
	restart_cooldown.start()

func change_map(scene, target):
	var current_stage = get_node('Stage')
	var flag = false
	if (current_stage != null):
		current_stage.remove_child(player)
		current_stage.queue_free()
		yield(get_tree(), 'fixed_frame')
		yield(get_tree(), 'fixed_frame')
	global.stage = scene
	var tmp = global.get_current_stage().instance()
	tmp.set_name('Stage')
	for i in tmp.get_children():
		if (i.get_name() == target):
			player.set_pos(i.get_pos())
			flag = true
	if (flag == false):
		player.set_pos(global.get_current_stage_respawn())
	tmp.add_child(player)
	self.add_child(tmp)

func quit():
	get_tree().quit()

func on_press_action(action):
	if action == ACT.INST:
		show_instructions()

func on_release_action(action):
	if action == ACT.INST:
		hide_instructions()

func show_instructions():
	hud.show()
	background.show()
	objective.show()

func hide_instructions():
	hud.hide()
	background.hide()
	objective.hide()
