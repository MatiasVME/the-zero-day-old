extends "GHUD.gd"

func _ready():
	$Buttons.connect("fire", self, "_on_fire")
	$Buttons.connect("select", self, "_on_select")
	
func _on_fire():
	hud_actor._fire_handler()
	
func _on_select():
	hud_actor.select_next()