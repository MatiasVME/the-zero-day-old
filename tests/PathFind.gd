extends Node2D

var camera

var paths

var gluton_pos

func _ready():
	var player = PlayerManager.init_player(0)
	add_child(player)
	player.position = $PlayerSpawn.position
	player.enable_player()
	
	$GameCamera.following = player
	$GameCamera.mode = $GameCamera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)

