extends Light2D

func change_to_green():
	self.set_color(Color(0, 1, 0))
	get_child(0).set_modulate(Color(0, 1, 0))

func change_to_red():
	self.set_color(Color(1, 0, 0))
	get_child(0).set_modulate(Color(1, 0, 0))
