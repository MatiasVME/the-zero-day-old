extends Node2D

func _on_Exit_pressed():
	DataManager.save_all_data()
	PlayerManager.clear_players()
	get_tree().change_scene("res://scenes/main_screens/temp_main_menu/TempMainMenu.tscn")
