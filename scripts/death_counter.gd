extends Label

func _ready():
	set_text('Number of tries: ' + var2str(global.death_count))
