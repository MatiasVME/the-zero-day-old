"""
	EquipmentFactory.gd es una factoría de items para usar en la batalla o herramientas,
se le pasa el item y devuelve el objeto a agregar al jugador. Por ejemplo se le pasa,
un item de espada, y devuelve la escena de espada para equipar en el GPlayer
"""

extends Node

var normal_gun = preload("res://scenes/weapons_in_battle/distance/normal_gun/NormalGun.tscn").instance()

func get_primary_weapon(melee_weapon : TZDMeleeWeapon):
	match melee_weapon.weapon_type:
		melee_weapon.WeaponType.NORMAL_SWORD:
			return normal_gun # NEEDFIX

func get_secundary_weapon(distance_weapon : TZDDistanceWeapon):
	pass

func get_tool():
	pass
