"""
ShootManager.gd


"""

extends Node

enum Bullet {
	NORMAL,
	PLASMA
}

func _physics_process(delta):
	pass

func fire(direction : Vector2, _bullet = Bullet.NORMAL, damage : int = 1, time_life : float = 3.0, trajectory : int = 0) -> GBullet:
	var bullet = get_bullet_instance(_bullet)
	bullet.direction = direction
	bullet.damage = damage
	
	return bullet
	
func get_bullet_instance(bullet):
	match bullet:
		Bullet.PLASMA:
			return load("res://scenes/actors/bullets/plasma/Plasma.tscn").instance()
		Bullet.NORMAL:
			return load("res://scenes/actors/bullets/common_bullet/CommonBullet.tscn").instance()