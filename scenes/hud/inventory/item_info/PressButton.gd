extends Control

tool

export(Texture) var icon setget set_icon
export(Vector2) var icon_size = Vector2(9,9) setget set_icon_size
export(Texture) var normal_texture setget set_normal_texture
export(Texture) var pressed_texture setget set_pressed_texture
export(String) var text = "x32" setget set_text
export(Color) var text_color setget set_text_color
export(int) var separation = 3 setget set_separation

signal button_down
signal button_up

func set_icon(_icon):
	icon = _icon
	if has_node("Container"):
		$Container/PropertyLabel/Icon/IconImage.texture = icon

func set_icon_size(_size):
	icon_size = _size
	if has_node("Container"):
		_update_size()

func set_normal_texture(_texture):
	normal_texture = _texture
	if has_node("Normal"):
		$Normal.texture = normal_texture

func set_pressed_texture(_texture):
	pressed_texture = _texture
	if has_node("Normal"):
		$Pressed.texture = pressed_texture
	
func set_text(_text):
	text = _text
	if has_node("Container"):
		$Container/PropertyLabel/Text.text = text
		$Container/PropertyLabel.rect_size = Vector2(0,0)
		_update_size()

func set_text_color(_text_color):
	text_color = _text_color
	if has_node("Container"):
		$Container/PropertyLabel/Text.add_color_override("font_color", text_color)

func set_separation(_separation):
	separation = _separation
	if has_node("Container"):
		$Container/PropertyLabel.add_constant_override("separation", separation)

func _ready():
	$Button.connect("button_down", self, "_on_button_down")
	$Button.connect("button_up", self, "_on_button_up")
	_update_size()

func _on_button_down():
	$Normal.hide()
	$Pressed.show()
	$Container.rect_position.y += 1
	emit_signal("button_down")
	
func _on_button_up():
	$Pressed.hide()
	$Normal.show()
	$Container.rect_position.y -= 1
	emit_signal("button_up")
	
func _update_size():
	$Container/PropertyLabel/Icon/IconImage.rect_min_size = icon_size
	$Container/PropertyLabel/Icon/IconImage.rect_size = icon_size
	$Container.rect_size = Vector2(0,0)
	self.rect_min_size = $Container.rect_size
	$Normal.rect_size = $Container.rect_size
	$Pressed.rect_size = $Container.rect_size
	$Button.rect_size = $Container.rect_size