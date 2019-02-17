extends Node2D

#Properties
var first_focus : Control
var press_any_key : = false
var focus : = false setget set_focus

func _ready():
	pass

func _input(event):
	if not focus:
		return
		
	if event is InputEventKey and not press_any_key:
		if not event.is_pressed():
			press_any_key = true
			first_focus.grab_focus()

func _on_mouse_lost_focus():
	press_any_key = false
	
func set_focus(val : bool) -> void:
	focus = val
	if val:
		press_any_key = false