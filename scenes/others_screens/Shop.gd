extends Node2D

func _ready():
	MusicManager.play(MusicManager.Music.SHOP_THEME)
	
	$PlayerInv.add_inventory(DataManager.get_current_inv())
