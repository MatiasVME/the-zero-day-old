extends Node2D
#Signals
signal play_pressed
signal options_pressed
signal credits_pressed

#Properties
onready var first_focus : BaseButton = $HorizontalContainer/VerticalContainer/MarginContainerPlay/Play
var press_any_key = false

func _ready():
	pass 

func _input(event):
	if event is InputEventKey and not press_any_key:
		if not event.is_pressed():
			press_any_key = true
			first_focus.grab_focus()
	pass

func _on_mouse_lost_focus():
	press_any_key = false
	pass


func _on_Play_pressed():
	emit_signal("play_pressed")
	pass

func _on_Credits_pressed():
	emit_signal("credits_pressed")
	pass



func _on_Options_pressed():
	emit_signal("options_pressed")
	pass
