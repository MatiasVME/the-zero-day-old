extends "res://scenes/main_screens/GMenuScreen.gd"
#Signals
signal play_pressed
signal options_pressed
signal credits_pressed

#Properties
onready var play : = $HorizontalContainer/VerticalContainer/MarginContainerPlay/Play

func _ready():
	first_focus = play
	connect("mouse_lost_focus", self, "_on_mouse_lost_focus")
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
