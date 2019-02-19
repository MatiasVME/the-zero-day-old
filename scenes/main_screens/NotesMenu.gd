extends "res://scenes/main_screens/GMenuScreen.gd"
signal back_from_notes_pressed

onready var button_back : = $HBoxContainer/CenterContainer/BackFromNotes
onready var text_notes : = $HBoxContainer/MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/TextNotes

func _ready():
	first_focus = button_back
	pass
	
func get_notes(path : String):
#Cargar notas e version
	pass

func _on_BackFromNotes_pressed():
	emit_signal("back_from_notes_pressed")


func _on_BackFromNotes_mouse_got_focus():
	pass # Replace with function body.
