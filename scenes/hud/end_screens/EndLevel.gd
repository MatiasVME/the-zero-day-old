extends Node2D

func _ready():
	CameraManager.set_camera_menu()
	CameraManager.current_camera.smoothing_speed = 15
	CameraManager.current_camera.global_position = $CamPos.global_position
	
	if Main.result == Main.Result.WIN:
		win()
	elif Main.result == Main.Result.LOSE:
		lose()
	else:
		pass
		
	Main.connect("win_adventure", self, "_on_win_adventure")
	Main.connect("lose_adventure", self, "_on_lose_adventure")
	
func win():
	$Title.text = "You Win!!"
	
	var music_arr = get_tree().get_nodes_in_group("Music")
	
	for music in music_arr:
		music.stop()
		
	PlayerManager.get_current_player().get_node("GWeaponInBattle").remove_weapon()
	PlayerManager.get_current_player().is_inmortal = true
	
	$Music.play()
	
	update_minerals()

func lose():
	$Title.text = "You Lose.."
	
func update_minerals():
	$Stats/Grid/IronEarned.text = str(Main.store_iron_earned)
	$Stats/Grid/TitaniumEarned.text = str(Main.store_titanium_earned)
	$Stats/Grid/SteelEarned.text = str(Main.store_steel_earned)
	$Stats/Grid/RubyEarned.text = str(Main.store_ruby_earned)

func _on_win_adventure():
	win()
	
func _on_lose_adventure():
	lose()
	
func _on_Resume_pressed():
	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/maps/adventure_mode/main_history/chapter_1/Map1Full.tscn")

func _on_Next_pressed():
#	get_tree().change_scene("")
	pass

func _on_Menu_pressed():
	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/main_screens/temp_main_menu/TempMainMenu.tscn")
