"""
	EquipmentFactory.gd es una factoría de items para usar en la batalla o herramientas,
se le pasa el item y devuelve el objeto a agregar al jugador. Por ejemplo se le pasa,
un item de espada, y devuelve la escena de espada para equipar en el GPlayer
"""

extends Node

var normal_gun = preload("res://scenes/weapons_in_battle/distance/normal_gun/NormalGun.tscn").instance()
var melee_normal_attack = preload("res://scenes/weapons_in_battle/melee/normal_attack/NormalAttack.tscn").instance()
var boxing_attack = preload("res://scenes/weapons_in_battle/melee/boxing_attack/BoxingAttack.tscn").instance()

func get_boxing_attack():
	return boxing_attack

func get_primary_weapon(melee_weapon : TZDMeleeWeapon):
	# TEMP
	if not melee_weapon:
		return
	
	match int(melee_weapon.weapon_type):
		melee_weapon.WeaponType.IRON_SWORD:
			melee_normal_attack.weapon = melee_weapon
			return melee_normal_attack
			# TODO
	
	print("no es iron es: ", melee_weapon.weapon_type)
	
	
func get_secondary_weapon(distance_weapon : TZDDistanceWeapon):
	# Por el momento todas las armas de distancia atacan de la
	# misma forma.
	normal_gun.weapon = distance_weapon
	return normal_gun
	
func get_tool():
	pass
