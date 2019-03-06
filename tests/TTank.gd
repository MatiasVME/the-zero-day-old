extends Node2D

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(140, 100)
	add_child(player)
	player.enable_player()
