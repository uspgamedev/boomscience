extends CollisionShape2D

func ready(): # Debugging Godot
	get_parent().remove_shape(0)
	get_parent().add_shape(get_shape())
