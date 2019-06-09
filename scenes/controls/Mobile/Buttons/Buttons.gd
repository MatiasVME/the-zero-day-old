extends Node2D

signal fire
signal select

func _on_Fire_pressed():
	emit_signal("fire")

func _on_Select_pressed():
	emit_signal("select")
