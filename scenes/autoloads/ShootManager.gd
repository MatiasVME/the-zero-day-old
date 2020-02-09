"""
ShootManager.gd


"""

extends Node

# Tipos de munición imagenes
#

var ammo_plasma = preload("res://scenes/items/ammo/plasma/plasma_bullet_ammo.png")
var ammo_normal = preload("res://scenes/items/ammo/normal/normal_bullet_ammo.png")

# Tipos de balas imagenes
#

var bullet_plasma = preload("res://scenes/actors/bullets/plasma/plasma_bala_01.png")
var bullet_normal = preload("res://scenes/actors/bullets/common_bullet/bullet_01.png")
var bullet_knockback = preload("res://scenes/actors/bullets/xor341-bullet/proyectil_01.png")

# Tipos de balas escenas
# 

var bullet_scn_plasma = preload("res://scenes/actors/bullets/plasma/Plasma.tscn")
var bullet_scn_normal = preload("res://scenes/actors/bullets/common_bullet/CommonBullet.tscn")
var bullet_scn_knockback = preload("res://scenes/actors/bullets/xor341-bullet/KnockBackBullet.tscn")

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
			return bullet_scn_plasma.instance()
		Bullet.NORMAL:
			return bullet_scn_normal.instance()
		Bullet.XOR341:
			return bullet_scn_knockback.instance()
	
	print("ERROR: no se encuentra la bullet: ", bullet_num)
	
func get_bullet_img(bullet_num):
	match int(bullet_num):
		Bullet.NORMAL:
			return bullet_normal
		Bullet.PLASMA:
			return bullet_plasma
		
func get_bullet_box_img(bullet_num):
	match int(bullet_num):
		Bullet.NORMAL:
			return ammo_normal
		Bullet.PLASMA:
			return ammo_plasma
		
