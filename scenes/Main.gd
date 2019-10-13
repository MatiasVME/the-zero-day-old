extends Node2D

func _ready():
	$Camera.smoothing_speed = 15
	$Camera.global_position = global_position
	
	$Version.text = Main.VERSION
	
	MusicManager.play(MusicManager.Music.PRELUDE)

func _on_Back_pressed():
	$Camera.global_position = global_position

func _on_BackFromCredits_pressed():
	$Camera.global_position = global_position

func _on_DeleteData_pressed():
	# TODO: Preguntar si esta seguro de borrar la data
	# o no.
	DataManager.remove_all_data()
	get_tree().quit()

func _on_Credits_pressed():
	var credits_pos = $Credits.global_position
	credits_pos.x = credits_pos.x + Main.RES_X / 2
	credits_pos.y = credits_pos.y + Main.RES_Y / 2
	
	$Camera.global_position = credits_pos
	$Credits._resume()

func _on_Play_pressed():
#	$Camera.global_position = $AdventureMode.global_position
	$Camera/Anim.play("Enter")

func _on_Config_pressed():
	var option_pos = $Options.global_position
	option_pos.x = option_pos.x + Main.RES_X / 2
	option_pos.y = option_pos.y + Main.RES_Y / 2
	
	$Camera.global_position = option_pos

func _on_Version_pressed():
	var version_pos = $VersionNotes.global_position
	version_pos.x = version_pos.x + Main.RES_X / 2
	version_pos.y = version_pos.y + Main.RES_Y / 2
	
	$Camera.global_position = version_pos

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Enter":
		get_tree().change_scene("res://scenes/main_screens/AdventureMode.tscn")
