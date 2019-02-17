extends Node2D

var hotbar_row : int = 1
var is_fulled : bool = false

var rows = []

var current_inv : RPGWeightInventory

signal item_added

func _ready():
	update()

# Actualiza el inventario en caso de un cambio
func update():
	create_row_if_can() # Test

# Añade un item al inventario
func add_item():
	# El inventario tiene la capacidad?
	
	# Añadir item
	
	pass
	
func drop_item():
	pass

# Elimina un item directamente
func remove_item():
	pass

# Hay slots disponibles? Puede que no existan ya que puede
# que el peso este completado
func has_slots():
	pass

# Crea una fila si es que puede. Esto depende si la ultima
# fila tiene capacidad o no para un item.
func create_row_if_can():
	# Caso no exista un row y caso en el cual el ultimo row este lleno
	if rows.size() < 1 or rows[rows.size() - 1].is_full():
		rows.append(load("res://scenes/hud/inventory/row/Row.tscn").instance())
		$Background/Container/MainColumn.add_child(rows[rows.size() - 1])
	
	
	
	
	
	