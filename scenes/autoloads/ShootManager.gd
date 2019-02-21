extends Node

enum Bullet {
	PLASMA
}
#var bullet = Bullet.PLASMA

func _physics_process(delta):
	pass

#
func fire(direction : Vector2, _bullet = Bullet.PLASMA, time_life : float = 5.0, trajectory : int = 0) -> GBullet:
	var bullet = get_bullet_instance(_bullet)
	bullet.direction = direction
#	var direction = (destination - origin.global_position).normalized()
	
	return bullet
	
func get_bullet_instance(bullet):
	match bullet:
		Bullet.PLASMA:
			return load("res://scenes/actors/bullets/plasma/Plasma.tscn").instance()