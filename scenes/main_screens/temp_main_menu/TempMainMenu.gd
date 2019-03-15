extends Node2D

func _ready():
	CameraManager.set_camera_menu()
	CameraManager.current_camera.smoothing_speed = 25
	CameraManager.current_camera.global_position = global_position
	
	$Version.text = Main.VERSION
	
func _on_ButtonAventureMode_pressed():
	CameraManager.current_camera.global_position = $AventureMode.global_position

func _on_Back_pressed():
	CameraManager.current_camera.global_position = global_position

func _on_ButtonCredits_pressed():
	CameraManager.current_camera.global_position = $Credits.global_position
	$Credits._resume()

func _on_BackFromCredits_pressed():
	CameraManager.current_camera.global_position = global_position
