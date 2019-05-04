extends Position2D

export (float) var CANNON_ANGULAR_VELOCITY = 1
var current_aim : Vector2
export (Texture) var cannon_up
export (Texture) var cannon_side
export (Texture) var cannon_down

func _ready():
	current_aim = Vector2(0, -1).rotated(rotation)


func aim(delta : float) -> void:
	rotation_degrees = int(rotation_degrees) % 180
	look_at(get_global_mouse_position())

#TODO: probar apuntado con retraso limitado por la velocidad de giro del Cannon
#	var angle_diff : float = (global_position + current_aim).angle_to_point(get_global_mouse_position())
#	current_aim = current_aim.rotated(angle_diff)
#	look_at(global_position + current_aim)


func set_cannon_sprite(degrees_change : float) -> void:
	var rot_degrees = (int(global_rotation_degrees) % 180 )
	if abs(rot_degrees) < 0 + degrees_change:
		$Cannon.texture = cannon_side
		$Cannon.flip_h = false
	elif abs(rot_degrees) < 180 - degrees_change:
		$Cannon.texture = cannon_down if rot_degrees > 0 else cannon_up
	else:
		$Cannon.texture = cannon_side
		$Cannon.flip_h = true


func fire():
	var bullet = ShootManager.fire(Vector2(0, - $Cannon.texture.get_height()).rotated(global_rotation + PI/2).normalized(), ShootManager.Bullet.XOR341, 1)
	bullet.global_position = global_position - Vector2(0, $Cannon.texture.get_height()).rotated(global_rotation + PI/2)
	bullet.rotation = global_rotation
	get_parent().get_parent().add_child(bullet)