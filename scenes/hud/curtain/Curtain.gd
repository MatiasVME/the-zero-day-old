extends Node2D

func anim_hit():
	$AnimHit.play("hit")
	
func anim_dead():
	$AnimDead.play("dead")