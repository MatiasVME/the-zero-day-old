extends Node2D

func _on_Config_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.show()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		
		$Inventory.pressed = false
		$Skills.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		
		$Anim.play_backwards("show")
		get_parent().get_node("Index/TogglePlayerMenu")

func _on_Inventory_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.show()
		$Panels/Skills.hide()
		
		$Config.pressed = false
		$Skills.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		
		$Anim.play_backwards("show")

func _on_Skills_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.show()
		
		$Config.pressed = false
		$Inventory.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		
		$Anim.play_backwards("show")
