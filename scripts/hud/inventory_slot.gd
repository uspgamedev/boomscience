extends PanelContainer

onready var frame = get_node('TextureFrame')

func _change_icon(texture):
	frame.set_texture(texture)