extends "res://scenes/main_screens/GMenuScreen.gd"
#Signals
signal campaign_pressed
signal multiplayer_pressed
signal back_pressed

#Properties
onready var campaign : = $VBoxContainer/HBoxContainer/Campaign

func _ready():
	first_focus = campaign

func _on_Campaign_pressed():
	emit_signal("campaign_pressed")

func _on_Multiplayer_pressed():
	emit_signal("multiplayer_pressed")

func _on_Back_pressed():
	emit_signal("back_pressed")
