extends "res://scenes/main_screens/GMenuScreen.gd"

signal back_from_credits_pressed

onready var button_back : = $MarginContainer/BackFromCredits
onready var sections : = $MarginContainer/CenterContainer/Sections
var index : int = 0

func _ready():
	first_focus = button_back
	for section in sections.get_children():
		section.connect("section_showed", self, "_on_section_showed")
#		Para realizar pruebas
#		_resume() 

func _on_section_showed() -> void:
	index += 1
	if index < sections.get_children().size():
		sections.get_children()[index].show_section()

func _resume() -> void:
	index = 0
	sections.get_children()[index].show_section()

func _on_BackFromCredits_pressed():
	if index < sections.get_children().size():
		sections.get_children()[index].stop_showing()
	emit_signal("back_from_credits_pressed")
