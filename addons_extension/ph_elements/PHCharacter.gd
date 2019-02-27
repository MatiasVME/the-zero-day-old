"""
PHCharacter.gd (Project Humanity Character)

Es una extencion y adaptacion del plugin RPGElements en especifico,
de RPGCharacter.

PHCharacter se encarga de administrar la logica y la informacion,
que contienen los personajes.
"""

extends RPGCharacter

class_name PHCharacter

enum PlayerType {
	DORBOT,
	MATBOT,
	PIXBOT,
	SERBOT
}
var player_type = PlayerType.MATBOT # Cambiar a DORBOT mas adelante

var unique_id : String

var equip : PHItem setget set_equip, get_equip

signal item_equiped(weapon)

func _init():
	randomize()
	unique_id = str(OS.get_unix_time(), "-", randi())

func set_equip(_equip : PHItem):
	equip = _equip
	emit_signal("item_equiped", _equip)
	
func get_equip():
	return equip
	
# Recarga dependiendo de la municion que reciba.
# devuelve true si se recarga completamente y
# false si no lo hace.
func reload(ammo : PHAmmo) -> bool:
	# Validar si puede hacer el reload
	# 1) Tiene que tener el arma equipada
	# 2) Tiene que haber municion disponible
	# 3) El equipamiento es un PHDistanceWeapon?
	if not equip and ammo.ammo_amount < 1:
		return false
	if not equip is PHDistanceWeapon:
		return false
	
	# Añadir ammo a la arma
	for i in equip.weapon_capacity:
		# Consultamos si esta lleno
		# Consultamos si no hay municion disponible
		if equip.current_shot == equip.weapon_capacity:
			# Retornar true si esta 100% recargado
			return true
		if ammo.ammo_amount < 1:
			return false
			
		equip.current_shot += 1
		ammo.ammo_amount -= 1
	
	# Nunca llega a esto (segun yo)
	return false

# Gasta una bala, devuelve true si se queda sin
# balas. Y false lo contrario.
func fire() -> bool:
	# Validar:
	# 1) No tiene un arma equipada?
	# 2) Tiene balas disponibles para usar?
	if not equip or equip.current_shot < 1:
		return false
	
	# De lo contrario...
	equip.current_shot -= 1
	return true