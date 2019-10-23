extends Node2D

func _ready():
	if AdventureManager.current_level >= 2:
		$Maps/Map2.visible = true

func _on_Map1_pressed():
	get_tree().change_scene_to(AdventureManager.get_level(1))

func _on_Map2_pressed():
	get_tree().change_scene_to(AdventureManager.get_level(2))

func _on_Back_pressed():
	# Temp
	get_tree().change_scene("res://scenes/Main.tscn")
