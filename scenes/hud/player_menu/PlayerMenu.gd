extends Node2D

# Actor actual, del cual se despliega la información
# en el player menu.
var current_actor setget set_current_actor

# Previene que se precione el boton mas de una vez
var prevents_double_toggle = false

signal menu_button_unpressed

func set_current_actor(actor : GActor):
	current_actor = actor
	
	$Panels/PlayersInfo.set_current_actor(actor)
	$Panels/PlayersInfo.update_all()

func hide_player_menu():
	$Panels/Menu.hide()
	$Panels/Inventory.hide()
	$Panels/Skills.hide()
	$Panels/PlayersInfo.hide()
		
	$Anim.play_backwards("show")
	get_tree().paused = false
	emit_signal("menu_button_unpressed")

func _on_Config_toggled(button_pressed):
	# Esto hace que se muestre el contenido del menu al estar presionado
	# el boton config. Esto es solo para config ya que en ocaciones quedaría
	# la configuración no mostrada. (si no existieran estas líneas)
	if button_pressed:
		$Panels/Menu.show()
	
	prevents_double_toggle = not prevents_double_toggle
	if prevents_double_toggle: return
	
	if button_pressed:
		$Panels/Menu.show()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()

		if $InfoPlayers.is_pressed():
			$InfoPlayers.pressed = false
		if $Inventory.is_pressed():
			$Inventory.pressed = false
		if $Skills.is_pressed():
			$Skills.pressed = false
	else:
		hide_player_menu()
	
func _on_Inventory_toggled(button_pressed):
	prevents_double_toggle = not prevents_double_toggle
	if prevents_double_toggle: return
	
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.show()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		prevents_double_toggle = false
		
		if $InfoPlayers.is_pressed():
			$InfoPlayers.pressed = false
		if $Config.is_pressed():
			$Config.pressed = false
		if $Skills.is_pressed():
			$Skills.pressed = false
	else:
		hide_player_menu()
		
func _on_Skills_toggled(button_pressed):
	prevents_double_toggle = not prevents_double_toggle
	if prevents_double_toggle: return
	
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.show()
		$Panels/PlayersInfo.hide()
		
		prevents_double_toggle = false
		
		$InfoPlayers.pressed = false
		$Config.pressed = false
		$Inventory.pressed = false
	else:
		hide_player_menu()
		
func _on_InfoPlayers_toggled(button_pressed):
	prevents_double_toggle = not prevents_double_toggle
	if prevents_double_toggle: return
	
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.show()
		
		prevents_double_toggle = false
		
		$Skills.pressed = false
		$Config.pressed = false
		$Inventory.pressed = false
	else:
		hide_player_menu()
		
