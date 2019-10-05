extends Node2D

# Signals
#signal splash_finished

func _on_AnimSplash_animation_finished(anim_name):
	if anim_name == "Intro":
#		emit_signal("splash_finished")
		$AnimSplash.play("finish")
#	elif anim_name == "finish":
#		queue_free()
	
