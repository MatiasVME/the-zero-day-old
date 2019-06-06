"""
Coloca el HUD adecuado segun el dispositivo.
"""

extends Node

var hud

func _ready():
	if OS.has_touchscreen_ui_hint():
		hud = load("res://scenes/hud/HUDMobile.tscn").instance()
		add_child(hud)
	else:
		# TEMP -->
		hud = load("res://scenes/hud/HUD_old.tscn").instance()
		add_child(hud)

func add_actor_to_hud(player : GActor):
	hud.add_actor_to_hud(player)

func set_hud_actor(player : GActor):
	hud.set_hud_actor(player)
