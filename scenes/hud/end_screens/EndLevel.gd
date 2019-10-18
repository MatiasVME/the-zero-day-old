extends Node2D

func _ready():	
	MusicManager.play(MusicManager.Music.END_LEVEL)
	
	if Main.result == Main.Result.WIN:
		win()
	elif Main.result == Main.Result.LOSE:
		lose()
	else:
		print_debug("No se a ganado ni perdido")
		pass
		
	Main.connect("win_adventure", self, "_on_win_adventure")
	Main.connect("lose_adventure", self, "_on_lose_adventure")
	
	$MoneyDisplay.amount_to_show(667)
	
func win():
	$Title.text = "YOU WIN!!"
		
	PlayerManager.get_current_player().get_node("GWeaponInBattle").remove_weapon()
	PlayerManager.get_current_player().is_inmortal = true
	
	update_minerals()

func lose():
	$Title.text = "YOU LOSE.."
	
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
#	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/maps/adventure_mode/main_history/chapter_1/Map1Full.tscn")

func _on_Next_pressed():
	pass

func _on_Menu_pressed():
#	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/main_screens/temp_main_menu/TempMainMenu.tscn")
