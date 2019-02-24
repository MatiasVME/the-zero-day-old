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
#	print("unique_id: ", unique_id)

func set_equip(_equip : PHItem):
	equip = _equip
	emit_signal("item_equiped", _equip)
	
func get_equip():
	return equip