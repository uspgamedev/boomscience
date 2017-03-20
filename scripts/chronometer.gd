extends Label

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	set_text('%02d:%02d' % [global.minute, global.second])
