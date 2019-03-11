"""
ShootManager.gd


"""

extends Node

enum Bullet {
	PLASMA,
	COMMON_BULLET
}

func _physics_process(delta):
	pass

func fire(direction : Vector2, _bullet = Bullet.PLASMA, damage : int = 1, time_life : float = 3.0, trajectory : int = 0) -> GBullet:
	var bullet = get_bullet_instance(_bullet)
	bullet.direction = direction
	bullet.damage = damage
	
	return bullet
	
func get_bullet_instance(bullet):
	match bullet:
		Bullet.PLASMA:
			return load("res://scenes/actors/bullets/plasma/Plasma.tscn").instance()
		Bullet.COMMON_BULLET:
			return load("res://scenes/actors/bullets/common_bullet/CommonBullet.tscn").instance()