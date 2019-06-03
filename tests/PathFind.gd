extends Node2D

var camera

var paths

var gluton_pos

func _ready():
	var player = PlayerManager.init_player(0)
	add_child(player)
	player.position = $PlayerSpawn.position
	player.enable_player()
	player.get_node("GInput").active()
	
	var player2 = PlayerManager.init_player(1)
	add_child(player2)
	player2.position = $PlayerSpawn.position + Vector2(30,30)
	player2.enable_player()
	player2.get_node("GInput").active(false)
	player2.get_node("GPlayerAI").active()
	player2.get_node("GPlayerAI").PLAYER_TARGET = player
	
	$GameCamera.following = player
	$GameCamera.mode = $GameCamera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)

