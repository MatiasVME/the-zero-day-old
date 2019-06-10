"""
ShootManager.gd


"""

extends Node

var plasma = preload("res://scenes/actors/bullets/plasma/Plasma.tscn")
var common_bullet = preload("res://scenes/actors/bullets/common_bullet/CommonBullet.tscn")
var knockback_bullet = preload("res://scenes/actors/bullets/xor341-bullet/KnockBackBullet.tscn")

enum Bullet {
	NORMAL,
	PLASMA,
	XOR341
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
			return plasma.instance()
		Bullet.NORMAL:
			return common_bullet.instance()
		Bullet.XOR341:
			return knockback_bullet.instance()
	
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
		