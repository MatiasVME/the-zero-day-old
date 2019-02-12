extends Position2D

export (float) var CANNON_ANGULAR_VELOCITY = 1
var current_aim : Vector2

func _ready():
	current_aim = Vector2(0, -1).rotated(rotation)

func aim(delta : float) -> void:
	rotation_degrees = int(rotation_degrees) % 180
	look_at(get_global_mouse_position())
#TODO: probar apuntado con retraso limitado por la velocidad de giro del Cannon
#	var angle_diff : float = (global_position + current_aim).angle_to_point(get_global_mouse_position())
#	current_aim = current_aim.rotated(angle_diff)
#	look_at(global_position + current_aim)