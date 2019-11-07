"""
TZDStructure.gd (The Zero Day Structure)

TODO - Descripción
"""

extends TZDCharacter

class_name TZDStructure

# Tipo de estructura
enum StructureType {
	Building,
	Defensive,
	Attack
}
var player_type = StructureType.Building # Cambiar a DORBOT mas adelante
