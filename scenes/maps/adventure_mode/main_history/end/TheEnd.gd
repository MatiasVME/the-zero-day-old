extends Node2D

func _ready():
	MusicManager.play(MusicManager.Music.SOLITUDE)
	$FullCredits/Anim.play("Show")