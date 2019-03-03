extends Node2D

onready var hud = get_parent()

var avatars = []

func add_avatar(actor : GActor):
	var avatar = load("res://scenes/hud/avatar_handler/Avatar.tscn").instance()
	$VBox.add_child(avatar)
	avatar.set_avatar_actor(actor)
	