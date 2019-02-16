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

func _init():
	randomize()
	unique_id = str(OS.get_unix_time(), "-", randi())
	print("unique_id: ", unique_id)
