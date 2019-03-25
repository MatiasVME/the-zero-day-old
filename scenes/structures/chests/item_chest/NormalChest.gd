extends GChest
"""
NormalChest es un cofre sin llave que puede contener items normales
"""

func _ready():
	pass

#Función sobreescrita de GChest que define la máquina de estados
func _change_state(new_state : int) -> bool:
	match new_state:
		States.CLOSED:
			if state == States.OPENED:
				state = new_state
		States.OPENED:
			if state == States.CLOSED:
				state = new_state
		_:
			return false
	return true