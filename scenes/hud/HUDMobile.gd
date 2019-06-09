extends "GHUD.gd"

func _ready():
	$Buttons.connect("fire", self, "_on_fire")
	$Buttons.connect("select", self, "_on_select")
	
func _on_fire():
	pass
	
func _on_select():
	hud_actor.select_next()