extends Node2D

class_name GChest

export (int) var capacity : int = 0 #Cantidad de items que puede contener
var content : Array #Arreglo con la informacion de los item que contiene
enum States {LOCKET, CLOSED, OPENED} #Estados temporales hasta definir herencia
export (States) var state : int = States.CLOSED

signal chest_opened
signal chest_closed
signal chest_locked

#TODO:Revisar que parametro usar para la info del Item
func add_item(item_data : PHItem) -> void:
	if content.size() < capacity:
		content.append(item_data)
		
#Retorna un PHItem y lo elimina del Array content si existe
#TODO:Revisar que usar para retornar la info del Item
func drop_item(index : int = 0) -> PHItem:
	var item : PHItem = null
	if content.size() > abs(index):
		item = content[index]
		content.remove(index)
	return item
	
func is_empty() -> bool:
	return content.empty()
	
func is_full() -> bool:
	return content.size() == capacity

#Funciones temporales para tratar de encapsular comportamiento
#TODO:Analizar si son necesarias
func open_chest() -> void:
	if _change_state(States.OPENED):
		emit_signal("chest_opened")
	
func close_chest() -> void:
	if _change_state(States.CLOSED):
		emit_signal("chest_closed")
	
func lock_chest() -> void:
	if _change_state(States.LOCKET):
		emit_signal("chest_locked")
	
func unlock_chest() -> void:
	if _change_state(States.CLOSE):
		emit_signal("chest_closed")

#Funcion que debe sobreescribirse en las subclases
func _change_state(new_state : int) -> bool:
	return false