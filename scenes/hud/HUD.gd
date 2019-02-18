extends CanvasLayer

func _on_Inventory_toggled(button_pressed):
	if button_pressed:
		$AnimInv.play("show")
	else:
		$AnimInv.play("hide")
