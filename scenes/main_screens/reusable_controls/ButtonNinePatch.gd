extends TextureButton
#Signals
signal mouse_lost_focus

#Properties
onready var rect = $RectNinePatch as NinePatchRect
export (Texture) var texture_rect_normal
export (Texture) var texture_rect_pressed
export (Texture) var texture_rect_focused

func _ready():
	pass

func _on_ButtonNinePatch_button_down():
	rect.texture = texture_rect_pressed as Texture
	pass

func _on_ButtonNinePatch_button_up():
	rect.texture = texture_rect_normal as Texture
	pass

func _on_ButtonNinePatch_focus_entered():
	modulate = Color.aqua
	self.grab_focus()
	rect.texture = texture_rect_focused as Texture
	pass

func _on_ButtonNinePatch_focus_exited():
	modulate = Color.white
	self.release_focus()
	rect.texture = texture_rect_normal as Texture
	pass

func _on_ButtonNinePatch_mouse_entered():
	_on_ButtonNinePatch_focus_entered()
	pass

func _on_ButtonNinePatch_mouse_exited():
	_on_ButtonNinePatch_focus_exited()
	emit_signal("mouse_lost_focus")
	pass
