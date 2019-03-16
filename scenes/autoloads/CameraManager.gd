# CameraManager.gd
# Se encargara de manejar las camaras
extends Node

var current_camera : Camera2D

func _ready():
	set_camera_game()

# Crea una nueva cámara
func create_new_camera(camera_name):
	var new_camera = Camera2D.new()
	add_child(new_camera)
	return new_camera

func set_camera_game():
	$CameraMenu.current = false
	current_camera = $CameraGame
	current_camera.current = true
	
	return current_camera
	
func set_camera_menu():
	$CameraGame.current = false
	current_camera = $CameraMenu
	current_camera.current = true
	
	return current_camera

func get_current():
	return current_camera