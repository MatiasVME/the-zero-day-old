extends Node2D

func _ready():
	pass

func _on_Exit_pressed():
	get_tree().change_scene("res://scenes/main_screens/temp_main_menu/TempMainMenu.tscn")
