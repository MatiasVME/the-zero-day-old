"""
PHStructure.gd (Project Humanity Structure)

TODO - Descripción
"""

extends RPGStructure

class_name PHStructure

# Tipo de estructura, quizá las refinerias y extractores hereden de aqui 
enum StructureType {
	Building,
	Defensive,
	Attack
}
var player_type = StructureType.Building # Cambiar a DORBOT mas adelante

var unique_id : String

func _init():
	randomize()
	unique_id = str(OS.get_unix_time(), "-", randi())
