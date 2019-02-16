extends Camera2D

var target : Node2D

func _ready():
	pass

func _physics_process(delta):
	if target:
		position = lerp(position, target.position, 0.05)