extends Node2D

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = $StartPosition.global_position
	add_child(player)
	player.enable_player()
	
	$GameCamera.following = player
	$GameCamera.mode = $GameCamera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)
