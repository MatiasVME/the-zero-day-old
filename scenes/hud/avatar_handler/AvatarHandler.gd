extends Node2D

onready var hud = get_parent()

func set_avatar_handler_actor(actor):
	# temp
	$VBox/Avatar.set_avatar_actor(actor)