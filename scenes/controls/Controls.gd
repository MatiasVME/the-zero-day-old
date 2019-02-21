extends Node2D

var can_fire : bool = true
#var current_player = null

signal fire(pos)

func _input(event):
	if can_fire and event.is_action_pressed("fire"):
		emit_signal("fire", get_global_mouse_position())
		
#func set_current_player(player):
#	current_player = player