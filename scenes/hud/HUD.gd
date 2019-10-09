"""
Coloca el HUD adecuado segun el dispositivo.
"""

extends Node

var hud

# TODO Preferir preload antes de load

func _ready():
	if OS.has_touchscreen_ui_hint() or Main.force_mobile_mode:
		hud = load("res://scenes/hud/HUDMobile.tscn").instance()
		Main.is_mobile = true
		add_child(hud)
	else:
		# TEMP -->
		hud = load("res://scenes/hud/HUD_old.tscn").instance()
		Main.is_mobile = false
		add_child(hud)

func add_actor_to_hud(player : GActor):
	hud.add_actor_to_hud(player)

func set_hud_actor(player : GActor):
	hud.set_hud_actor(player)
	player.set_hud(hud)
