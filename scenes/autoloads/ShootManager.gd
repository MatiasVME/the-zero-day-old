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
	
func get_bullet_instance(bullet_num):
	match int(bullet_num):
		Bullet.PLASMA:
			return load("res://scenes/actors/bullets/plasma/Plasma.tscn").instance()
		Bullet.NORMAL:
			return load("res://scenes/actors/bullets/common_bullet/CommonBullet.tscn").instance()
	
	print("ERROR: no se encuentra la bullet: ", bullet_num)
	
func get_bullet_img(bullet_num):
	match int(bullet_num):
		Bullet.NORMAL:
			return "res://scenes/actors/bullets/common_bullet/bullet_01.png"
		Bullet.PLASMA:
			return "res://scenes/actors/bullets/plasma/plasma_bala_01.png"
		
func get_bullet_box_img(bullet_num):
	match int(bullet_num):
		Bullet.NORMAL:
			return "res://scenes/items/ammo/normal/normal_bullet_ammo.png"
		Bullet.PLASMA:
			return "res://scenes/items/ammo/plasma/plasma_bullet_ammo.png"
		