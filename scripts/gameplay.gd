
extends Node

onready var player = get_node('Player')
onready var input = get_node('/root/input')

func load_camera():
    var camera = Camera2D.new()
    camera.set_enable_follow_smoothing(true)
    camera.set_follow_smoothing(5)
    player.add_child(camera)
    camera.make_current()

func _ready():
    load_camera()
    input.connect('press_quit', self, 'quit')

func quit():
    get_tree().quit()