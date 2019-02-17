extends Node2D
#Signals
signal splash_finished

func _ready():
	pass

func _on_AnimationSplash_animation_finished(anim_name):
	if anim_name == "Intro":
		emit_signal("splash_finished")
	pass