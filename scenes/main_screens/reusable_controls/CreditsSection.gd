extends Control

class_name CreditSection

signal section_showed

export (String) var name_section
export (Color) var color_section = Color.green
export (PoolStringArray) var name_staff
export (Color) var color_staff = Color.white

onready var section_label : Label = $VBoxContainer/Section
onready var staff_label : Label = $VBoxContainer/Staff
onready var animation : AnimationPlayer = $AnimationPlayer
var full_alpha : = Color(0xffffff00)

func _ready():
	section_label.modulate = full_alpha
	section_label.text = name_section
	section_label.set("custom_colors/font_color", color_section)
	staff_label.modulate = full_alpha
	staff_label.text = ""
	staff_label.set("custom_colors/font_color", color_staff)
	for name in name_staff:
		staff_label.text = staff_label.text + name + "\n"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Intro":
		animation.play("Outro")
	elif anim_name == "Outro":
		emit_signal("section_showed")

func show_section() -> void:
		animation.play("Intro")

func stop_showing() -> void:
	animation.set_current_animation("Intro")
	animation.seek(0, true)
	animation.stop(true)