"""
	EquipmentFactory.gd es una factoría de items para usar en la batalla o herramientas,
se le pasa el item y devuelve el objeto a agregar al jugador. Por ejemplo se le pasa,
un item de espada, y devuelve la escena de espada para equipar en el GPlayer
"""

extends Node

func get_primary_weapon(melee_weapon : TZDMeleeWeapon):
	pass

func get_secundary_weapon(distance_weapon : TZDDistanceWeapon):
	pass
	
func get_tool():
	pass
