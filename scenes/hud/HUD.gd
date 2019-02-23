extends CanvasLayer

func _on_Inventory_toggled(button_pressed):
	if button_pressed:
		$AnimInv.play("show")
	else:
		$AnimInv.play("hide")

# Establece un actor al HUD, para que se conecten las
# señales necesarias relacionadas con el HUD y los nodos
# mas internos.
func set_hud_actor(actor : GActor):
	$Hotbar.set_hotbar_actor(actor)