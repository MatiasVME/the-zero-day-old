extends Node2D

signal fire
signal select
signal select_next_item_up
signal select_next_item_down
signal toggle_player_menu_pressed(toggled)

func _on_Fire_pressed():
	emit_signal("fire")

func _on_Select_pressed():
	emit_signal("select")

func _on_SelectNextItemUp_pressed():
	emit_signal("select_next_item_up")

func _on_SelectNextItemDown_pressed():
	emit_signal("select_next_item_down")

func _on_TogglePlayerMenu_toggled(button_pressed):
	emit_signal("toggle_player_menu_pressed", button_pressed)
