extends Node2D

func _ready():
	get_tree().paused = false
	MusicManager.play(MusicManager.Music.END_LEVEL)
	
	if Main.result == Main.Result.WIN:
		win()
	elif Main.result == Main.Result.LOSE:
		lose()
	else:
		print_debug("No se a ganado ni perdido")
	
	$MoneyDisplay.amount_to_show(Main.store_money)
	
func win():
	$Title.text = "YOU WIN!!"
	
	if AdventureManager.current_level + 1 <= AdventureManager.ADVENTURE_LEVEL_MAX:
		if AdventureManager.current_level + 1 > AdventureManager.current_maximum_level:
			AdventureManager.current_maximum_level += 1
	else:
		print_debug("Se a llegado al nivel maximo")
	
func lose():
	$Title.text = "YOU LOSE.."
	
	Main.store_money = round(Main.store_money / 2)

func _on_Next_pressed():
	get_tree().change_scene_to(AdventureManager.get_level(AdventureManager.current_level + 1))

func _on_Menu_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/maps/adventure_mode/main_history/chapter_1/Map1Full.tscn")
