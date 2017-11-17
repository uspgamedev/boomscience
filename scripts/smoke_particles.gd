extends Node2D

onready var active_timer = get_node('ActiveTimer')
onready var fade_out = get_node('FadeOut')
onready var tween = get_node('Tween')
onready var area = get_node('SmokeArea')

func _ready():
	active_timer.connect('timeout', self, '_start_fade')
	fade_out.connect('timeout', self, '_free')
	set_fixed_process(true)

func _fixed_process(delta):
	for i in area.get_overlapping_areas():
		if (i.is_in_group('enemy_area')):
			print('in smoke')

func _start_fade():
	tween.interpolate_property(self, 'visibility/opacity', \
		1, 0, fade_out.get_wait_time(), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	fade_out.start()

func _free():
	self.queue_free()
