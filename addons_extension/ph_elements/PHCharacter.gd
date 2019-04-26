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
var player_type = PlayerType.DORBOT setget set_player_type, get_player_type

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
	
func set_player_type(_player_type):
	player_type = _player_type
	character_name = _get_character_name(player_type)
	
func get_player_type():
	return player_type

# Metodos "Privados"
#

func _get_character_name(player_type):
	match player_type:
		PlayerType.DORBOT:
			return "Dorbot"
		PlayerType.MATBOT:
			return "Matbot"
		PlayerType.PIXBOT:
			return "Pixbot"
		PlayerType.SERBOT:
			return "Serbot"