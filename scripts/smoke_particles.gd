extends Node2D

onready var active_timer = get_node('ActiveTimer')
onready var fade_out = get_node('FadeOut')
onready var tween = get_node('Tween')

func _ready():
	active_timer.connect('timeout', self, '_start_fade')
	fade_out.connect('timeout', self, '_free')

func _start_fade():
	fade_out.start()

func _free():
	self.queue_free()
