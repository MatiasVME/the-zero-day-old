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
		pass
		
	Main.connect("win_adventure", self, "_on_win_adventure")
	Main.connect("lose_adventure", self, "_on_lose_adventure")
	
	$MoneyDisplay.amount_to_show(Main.store_money)
	
func win():
	$Title.text = "YOU WIN!!"

func lose():
	$Title.text = "YOU LOSE.."
	
	Main.store_money = int(round(Main.store_money / 2))
	
	print_debug("Lose, ", Main.store_money)

func _on_win_adventure():
	win()
	
func _on_lose_adventure():
	lose()
	
func _on_Next_pressed():
	pass

func _on_Menu_pressed():
#	Main.prepare_to_exit()
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/maps/adventure_mode/main_history/chapter_1/Map1Full.tscn")

