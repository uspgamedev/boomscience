extends Sprite

export(NodePath) var target_path

var target

func _ready():
	if (target_path != null):
		target = get_node(target_path).get_pos()

func get_target():
	return target
