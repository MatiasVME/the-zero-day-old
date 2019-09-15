extends "GHUD.gd"

onready var inventory = get_node("PlayerMenu/Panels/Inventory")

func _ready():
	$Buttons.connect("action", self, "_on_action")
	$Buttons.connect("select", self, "_on_select")
	$Buttons.connect("select_next_item_up", self, "_on_select_next_item_up")
	$Buttons.connect("select_next_item_down", self, "_on_select_next_item_down")
	$Buttons.connect("toggle_player_menu_pressed", self, "_on_toggle_player_menu_pressed")
	$Buttons.connect("dash_pressed", self, "_on_dash_pressed")
	$Buttons.connect("dash_realeased", self, "_on_dash_released")
	
	$PlayerMenu.connect("menu_button_unpressed", self, "_on_player_menu_button_unpressed")

func set_hud_actor(actor : GActor):
	.set_hud_actor(actor)
	
	$PlayerMenu.set_current_actor(actor)

func _on_action():
	hud_actor._fire_handler()
	
func _on_select():
	hud_actor.select_next()

func _on_select_next_item_up():
	$Hotbar.limited_next_slot()
	
func _on_select_next_item_down():
	$Hotbar.limited_next_slot(true)
	
func _on_toggle_player_menu_pressed(toggled):
	if toggled:
		$PlayerMenu/Anim.play("show")
		
		# Si no hay ningún boton del menú presionado,
		# presiona config.
		if not ($PlayerMenu/Config.is_pressed() or $PlayerMenu/Inventory.is_pressed() or $PlayerMenu/Skills.is_pressed()):
			$PlayerMenu._on_Config_toggled(true)
			$PlayerMenu/Config.pressed = true
	else:
		$PlayerMenu/Anim.play_backwards("show")

	get_tree().paused = toggled

func _on_player_menu_button_unpressed():
	$Buttons/Index/TogglePlayerMenu.pressed = false

func _on_dash_pressed():
	hud_actor.dash_start()
	
func _on_dash_released():
	hud_actor.dash_stop()

