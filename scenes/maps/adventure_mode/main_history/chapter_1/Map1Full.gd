extends Node2D

var camera

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(256, 369)
	add_child(player)
	player.enable_player()
	
	camera = CameraManager.set_camera_game()
	camera.following = player
	camera.mode = camera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)