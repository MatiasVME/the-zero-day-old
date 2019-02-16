extends Node2D

const CameraMenu = preload("res://tests/test_menu_screens/CameraMenu.gd")
onready var camera : CameraMenu = $CameraMenu
onready var main_menu = $MainMenu

func _ready():
	camera.target = main_menu
	pass

func _on_MainMenu_play_pressed():
#Cambiar a menu Play
	camera.target = main_menu
	pass

func _on_MainMenu_options_pressed():
#Cambiar a menu Options
	camera.target = $MainMenu2
	pass

func _on_MainMenu_credits_pressed():
#Cambiar a menu Credits
	pass
