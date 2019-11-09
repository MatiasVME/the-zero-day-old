extends Node2D

func _ready():
	MusicManager.play(MusicManager.Music.SHOP_THEME)
	
	$Dorbot/Sprites/AnimMove.play("Run")
	$Dogbot/Anims.play("Run")
