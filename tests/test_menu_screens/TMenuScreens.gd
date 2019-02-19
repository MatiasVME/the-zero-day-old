extends Node2D

const CameraMenu = preload("res://tests/test_menu_screens/CameraMenu.gd")
onready var camera : CameraMenu = $CameraMenu
onready var main_menu : = $MainMenu
onready var splash : = $Splash
onready var play_menu : = $Play
onready var notes_menu : = $NotesMenu

func _ready():
	camera.target = splash
	pass

func _on_MainMenu_play_pressed():
#Cambiar a menu Play
	camera.target.focus = false
	camera.target = play_menu
	camera.target.focus = true
	pass

func _on_MainMenu_options_pressed():
#Cambiar a menu Options
	pass

func _on_MainMenu_credits_pressed():
#Cambiar a menu Credits
	pass

func _on_Splash_splash_finished():
	camera.target = main_menu
	camera.target.focus = true
	pass

func _on_Play_back_pressed():
	camera.target.focus = false
	camera.target = main_menu
	camera.target.focus = true

func _on_CameraMenu_target_reached():
	if splash and camera.target != splash:
		splash.queue_free()
		splash = null


func _on_NotesMenu_back_from_notes_pressed():
	camera.target.focus = false
	camera.target = main_menu
	camera.target.focus = true


func _on_MainMenu_notes_pressed():
	camera.target.focus = false
	camera.target = notes_menu
	camera.target.focus = true