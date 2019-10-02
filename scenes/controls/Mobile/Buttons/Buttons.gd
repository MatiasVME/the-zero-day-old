extends Node2D

signal action_pressed
signal action_released
signal dash_pressed
signal dash_realeased
signal select
signal select_next_item_up
signal select_next_item_down
signal toggle_player_menu_pressed(toggled)

func _on_Select_pressed():
	emit_signal("select")

func _on_SelectNextItemUp_pressed():
	emit_signal("select_next_item_up")

func _on_SelectNextItemDown_pressed():
	emit_signal("select_next_item_down")

func _on_TogglePlayerMenu_toggled(button_pressed):
	emit_signal("toggle_player_menu_pressed", button_pressed)

func _on_Action_pressed():
	emit_signal("action_pressed")

func _on_Dash_pressed():
	emit_signal("dash_pressed")

func _on_Dash_released():
	emit_signal("dash_realeased")

func _on_Action_released():
	emit_signal("action_released")
