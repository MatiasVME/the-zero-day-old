extends Node2D

class_name CreditSection
#Signals
signal section_showed
export (String) var name_section
export (PoolStringArray) var name_staff

onready var section_label : Label = $VBoxContainer/Section
onready var staff_label : Label = $VBoxContainer/Staff
onready var animation : AnimationPlayer = $AnimationPlayer

func _ready():
	section_label.text = name_section
	staff_label.text = ""
	for name in name_staff:
		staff_label.text = staff_label.text + name + "\n"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Intro":
		animation.play("Outro")
	elif anim_name == "Outro":
		emit_signal("section_showed")
