extends Node2D

func _ready():
	if Main.ot_splash: 
		Main.ot_splash = false
		$AnimSplash.play("Intro")
	else:
		$AnimSplash.play("finish")

func _on_AnimSplash_animation_finished(anim_name):
	if anim_name == "Intro":
		$AnimSplash.play("finish")
	
