extends Node2D

func _on_Exit_pressed():
	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/main_screens/temp_main_menu/TempMainMenu.tscn")
