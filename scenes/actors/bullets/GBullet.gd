extends KinematicBody2D

class_name GBullet

enum Trajectory {
	LINEAL,
	SEEKER
}
var trajectory = Trajectory.LINEAL
#var origin : Vector2
var direction : Vector2

func _physics_process(delta):
	if trajectory == Trajectory.LINEAL:
		move_and_slide(direction * delta * 10000)