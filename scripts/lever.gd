extends Sprite

onready var timer = get_node("Timer")
onready var initial_pos = get_pos()

func pull():
	set_pos(initial_pos + Vector2(0,8))
	timer.start()
	yield(timer, "timeout")
	set_pos(initial_pos)
