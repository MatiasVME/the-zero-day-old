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
	
