extends Node2D

onready var hud = get_parent()

var avatars = []
var avatar_selected

func _ready():
	PlayerManager.connect("player_changed", self, "_on_player_changed")

func add_avatar(actor : GActor):
	var avatar = load("res://scenes/hud/avatar_handler/Avatar.tscn").instance()
	avatar.add_avatar_actor(actor)
	$VBox.add_child(avatar)
	avatars.append(avatar)

func select_avatar(actor : GActor):
	if avatar_selected:
		avatar_selected.deselect()
	
	for avatar in avatars:
		if avatar.actor == actor:
			avatar_selected = avatar
			avatar_selected.select()
			break

func _on_player_changed(player):
	select_avatar(player)