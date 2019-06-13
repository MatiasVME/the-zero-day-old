extends "GHUD.gd"

func _ready():
	$Buttons.connect("fire", self, "_on_fire")
	$Buttons.connect("select", self, "_on_select")
	$Buttons.connect("select_next_item_up", self, "_on_select_next_item_up")
	$Buttons.connect("select_next_item_down", self, "_on_select_next_item_down")
	
func _on_fire():
	hud_actor._fire_handler()
	
func _on_select():
	hud_actor.select_next()

func _on_select_next_item_up():
	$Hotbar.limited_next_slot()
	
func _on_select_next_item_down():
	$Hotbar.limited_next_slot(true)
	