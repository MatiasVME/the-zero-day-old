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
	
func win():
	$Title.text = "You Win!!"
	
	$Stats/Grid/IronEarned.text = str(Main.store_iron_earned)

func lose():
	$Title.text = "You Lose.."