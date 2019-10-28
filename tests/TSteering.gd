extends Node2D

var velocity := Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	velocity = Steering.follow(
		velocity,
		$BodyTest.global_position,
		get_global_mouse_position(),
		150.0,
		20.0
	)
	$BodyTest.move_and_slide(velocity)