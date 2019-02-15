extends Node2D

func _ready():
	PlayerManager.current_player = $Matbot
	$Matbot.can_move = true

