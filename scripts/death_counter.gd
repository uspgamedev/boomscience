extends Label

func _ready():
	update_death_counter()

func update_death_counter():
	set_text('Number of tries: ' + var2str(global.death_count))
