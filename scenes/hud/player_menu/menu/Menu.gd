extends Node2D

func _on_SaveAndExit_pressed():
	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/Main.tscn")

