extends Node2D

func anim_hit():
	$Hit/AnimHit.play("hit")
	
func anim_dead():
	$Dead/AnimDead.play("dead")
	
func anim_start():
	$StartEnd/AnimStartEnd.play("Start")

func anim_end():
	$StartEnd/AnimStartEnd.play("End")