extends Node2D

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(150, 100)
	add_child(player)
	
	player.can_move = true

