extends HBoxContainer

tool

export(Texture) var icon setget set_icon
export(Vector2) var icon_size = Vector2(10,10) setget set_icon_size
export(String) var text = "prop" setget set_text
export(Color) var text_color setget set_text_color

func set_icon(_icon):
	icon = _icon
	if has_node("Icon"):
		$Icon/IconImage.texture = icon

func set_icon_size(_size):
	icon_size = _size
	if has_node("Icon"):
		$Icon/IconImage.rect_size = icon_size
		$Icon/IconImage.rect_min_size = icon_size

func set_text(_text):
	text = _text
	if has_node("Text"):
		$Text.text = text
		self.rect_size = Vector2(0,0)

func set_text_color(_text_color):
	text_color = _text_color
	if has_node("Text"):
		$Text.add_color_override("font_color", text_color)