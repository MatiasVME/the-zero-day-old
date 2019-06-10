"""
ShootFactory.gd


"""

extends Node

var plasma = preload("res://scenes/actors/bullets/plasma/Plasma.tscn")

enum Bullet {
	PLASMA
}

static func fire(direction : Vector2, _bullet = Bullet.PLASMA, time_life : float = 5.0, trajectory : int = 0) -> GBullet:
	var bullet = get_bullet_instance(_bullet)
	bullet.direction = direction
		
	return bullet
	
static func get_bullet_instance(bullet):
	match bullet:
		Bullet.PLASMA:
			return plasma.instance()