extends Node

func _ready():
	MusicManager.play(MusicManager.Music.THE_EMPIRE)
	
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(420, 226)
	$YSort.add_child(player)
	player.enable_player()
	
	$HUD.add_actor_to_hud(player)
	$HUD.set_hud_actor(player)
	$GameCamera.following = player
	player.game_camera = $GameCamera