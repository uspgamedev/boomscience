
extends SceneTree

const Input = preload("input.gd")

var root
var root_node
var input

func create_input_node():
	var node = Node.new()
	node.set_script(Input)
	return node

func _init():
	root = get_root()
	root_node = Node.new()
	input = create_input_node()
	root.add_child(root_node)
	root_node.add_child(input)

