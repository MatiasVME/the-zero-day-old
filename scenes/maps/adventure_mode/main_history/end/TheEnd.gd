extends Node2D

func _ready():
	MusicManager.play(MusicManager.Music.SOLITUDE)
	$FullCredits/Anim.play("Show")

func _on_Menu_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
