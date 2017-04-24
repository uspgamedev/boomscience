extends RichTextLabel

onready var page = 1

func next_page():
	if (get_children().size() -1 >= page):
		clear()
		add_text(get_children()[page].text)
		page += 1
		return true
	else:
		page = 1
		return false
