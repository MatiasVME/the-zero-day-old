extends Node2D

func _ready():
	$Camera.smoothing_speed = 15
	$Camera.global_position = global_position
	
	$Version.text = Main.VERSION

func _on_Back_pressed():
	$Camera.global_position = global_position

func _on_ButtonCredits_pressed():
	$Camera.global_position = $Credits.global_position
	$Credits._resume()

func _on_BackFromCredits_pressed():
	$Camera.global_position = global_position

func _on_ButtonAdventureMode_pressed():
	$Camera.global_position = $AdventureMode.global_position

func _on_DeleteData_pressed():
	DataManager.remove_all_data()
	get_tree().quit()
