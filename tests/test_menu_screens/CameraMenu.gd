extends Camera2D

signal target_reached

var target : Node2D setget set_target, get_target
var reached : bool

func _ready():
	pass
	
func _physics_process(delta):
	if target:
		position = lerp(position, target.position, 0.05)
		
		if not reached and (position - target.position).length() < 1:
			reached = true
			emit_signal("target_reached")

func set_target(node : Node2D) -> void:
	target = node
	reached = false
	
func get_target() -> Node2D:
	return target
