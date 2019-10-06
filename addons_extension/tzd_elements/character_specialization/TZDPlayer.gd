extends TZDCharacter

class_name TZDPlayer

var player_type = Enums.PlayerType.DORBOT setget set_player_type, get_player_type

var special_dash_damage = 5

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

signal primary_weapon_equiped(weapon)
signal secondary_weapon_equiped(weapon)

func set_primary_weapon(_primary_weapon : TZDMeleeWeapon):
	primary_weapon = _primary_weapon
	emit_signal("primary_weapon_equiped", primary_weapon)
	
func get_primary_weapon():
	return primary_weapon
	
func set_secondary_weapon(_secondary_weapon : TZDDistanceWeapon):
	if not _secondary_weapon:
		return
	
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

static func character2dict(_character : RPGCharacter):
	var primary_weapon
	var secondary_weapon
	
	if _character.primary_weapon:
		primary_weapon = RPGElement.gdc2gd(inst2dict(_character.primary_weapon))
	
	if _character.secondary_weapon:
		secondary_weapon = RPGElement.gdc2gd(inst2dict(_character.secondary_weapon))
	
	var character_dict = RPGElement.gdc2gd(inst2dict(_character))
	character_dict["primary_weapon"] = primary_weapon
	character_dict["secondary_weapon"] = secondary_weapon
	
	return character_dict

static func dict2character(_dict_character : Dictionary):
	var primary_weapon
	var secondary_weapon
	
	if _dict_character["primary_weapon"]:
		primary_weapon = dict2inst(_dict_character["primary_weapon"])
		_dict_character["primary_weapon"] = null
	
	if _dict_character["secondary_weapon"]:
		secondary_weapon = dict2inst(_dict_character["secondary_weapon"])
		_dict_character["secondary_weapon"] = null
	
	var character_inst = dict2inst(_dict_character)
	character_inst.primary_weapon = primary_weapon
	character_inst.secondary_weapon = secondary_weapon
	
	return character_inst

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