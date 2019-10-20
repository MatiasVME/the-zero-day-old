extends Node2D

func anim_hit():
	$Hit/AnimHit.play("hit")
	
func anim_dead():
	$Dead/AnimDead.play("dead")
	
func anim_start():
	$StartEnd/AnimStartEnd.play("Start")

func anim_end_lose():
	$StartEnd/AnimStartEnd.play("EndLose")
	
func anim_end_win():
	$StartEnd/AnimStartEnd.play("EndWin")

func _on_AnimStartEnd_animation_finished(anim_name):
	if anim_name == "EndWin":
		Main.win_adventure()
