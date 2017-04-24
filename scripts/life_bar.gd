extends ProgressBar

func change_life(life, amount):
	var tween = get_node('ChangeStatus')
	tween.interpolate_property(self, "range/value", life, life + amount, .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
