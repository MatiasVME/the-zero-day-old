extends Node2D

onready var hud = get_parent()

var avatars = []

func _ready():
	PlayerManager.connect("player_changed", self, "_on_player_changed")

func add_avatar(actor : GActor):
	var avatar = load("res://scenes/hud/avatar_handler/Avatar.tscn").instance()
	avatar.add_avatar_actor(actor)
	$VBox.add_child(avatar)

func _on_player_changed(player):
	for avatar in avatars:
		pass