"""
TZDCharacter.gd (Project Humanity Character)

Es una extencion y adaptacion del plugin RPGElements en especifico,
de RPGCharacter.

TZDCharacter se encarga de administrar la logica y la informacion,
que contienen los personajes.
"""

extends RPGCharacter

class_name TZDCharacter

var player_type = Enums.PlayerType.DORBOT setget set_player_type, get_player_type

var unique_id : String

# Obsoleto -->
var equip : TZDItem setget set_equip, get_equip

# Arma primaria (Melee)
var primary_weapon : TZDMeleeWeapon setget set_primary_weapon, get_primary_weapon
# Arma secundaria (Distance)
var secondary_weapon : TZDDistanceWeapon setget set_secondary_weapon, get_secondary_weapon

# La estamina es el gasto de esfuerzo físico al hacer dash o otras
# actividades, que requieran estamina
var stamina := 100.0 setget set_stamina, get_stamina
var stamina_max := 100.0 setget set_stamina_max, get_stamina_max

signal stamina_changed(new_stamina_value)
signal stamina_max_changed(new_stamina_max_value)

# Dinero que dropea
var money_drop = 1

signal item_equiped(weapon)

signal primary_weapon_equiped(weapon)
signal secondary_weapon_equiped(weapon)

#func _init():
#	randomize()
#	unique_id = str(OS.get_unix_time(), "-", randi())

func set_primary_weapon(_primary_weapon : TZDMeleeWeapon):
	primary_weapon = _primary_weapon
	emit_signal("primary_weapon_equiped", primary_weapon)
	
func get_primary_weapon():
	return primary_weapon
	
func set_secondary_weapon(_secondary_weapon :TZDDistanceWeapon):
	secondary_weapon = _secondary_weapon
	emit_signal("secondary_weapon_equiped", secondary_weapon)

func get_secondary_weapon():
	return secondary_weapon

func set_player_type(_player_type):
	player_type = _player_type
	character_name = _get_character_name(player_type)
	
func get_player_type():
	return player_type

# La stamina nunca supera a stamina_max
func set_stamina(_stamina):
	var old_stamina = stamina
	
	if stamina > stamina_max:
		stamina = stamina_max
	else:
		stamina = _stamina
	
	if old_stamina != stamina:
		emit_signal("stamina_changed", stamina)
	
func get_stamina():
	return stamina

func set_stamina_max(_stamina_max):
	stamina_max = _stamina_max
	
	emit_signal("stamina_max_changed", stamina_max)
	
func get_stamina_max():
	return stamina_max

# Obsoletos:
#

func set_equip(_equip : TZDItem):
	equip = _equip
	emit_signal("item_equiped", _equip)
	
func get_equip():
	return equip

# Metodos "Privados"
#

func _get_character_name(player_type):
	match player_type:
		Enums.PlayerType.DORBOT:
			return "Dorbot"
		Enums.PlayerType.MATBOT:
			return "Matbot"
		Enums.PlayerType.PIXBOT:
			return "Pixbot"
		Enums.PlayerType.SERBOT:
			return "Serbot"