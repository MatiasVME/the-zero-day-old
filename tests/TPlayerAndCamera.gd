extends Node2D

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(10, 10)
	add_child(player)
	player.enable_player()
	
	$HUD.add_to_hud(player)
	$HUD.set_hud_actor(player)
	$GameCamera.following = player
	
	var player2 = PlayerManager.init_player(1)
	player2.global_position = Vector2(100, 100)
	add_child(player2)
	$HUD.add_to_hud(player2)
	
	var player3 = PlayerManager.init_player(2)
	player3.global_position = Vector2(100, 140)
	add_child(player3)
	$HUD.add_to_hud(player3)
	
	var player4 = PlayerManager.init_player(3)
	player4.global_position = Vector2(100, 180)
	add_child(player4)
	$HUD.add_to_hud(player4)
	