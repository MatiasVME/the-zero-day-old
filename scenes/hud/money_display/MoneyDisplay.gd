extends Node2D

func _ready():
	update_display_money()
	
func update_display_money():
	$Label.text = str(DataManager.data_user["Money"])
