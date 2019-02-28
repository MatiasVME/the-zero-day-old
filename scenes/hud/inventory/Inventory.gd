extends Node2D

var hotbar_row : int = 1
var is_fulled : bool = false

# Contiene instancias de Row.tcn
var rows = []

var current_inv : RPGWeightInventory

signal item_added

func _ready():
	DataManager.get_current_inv().connect("item_added", self, "_on_item_added")
	
	PlayerManager.connect("player_shooting", self, "_on_player_shooting")
	
	update()

# Actualiza el inventario en caso de un cambio
func update():
	create_row_if_can()
	
	for item in DataManager.get_current_inv().inv:
		# Ve si el item es municion y si esta vacia
		# la borra
		if item is PHAmmo and item.ammo_amount == 0:
			print("removiendo item: ", item)
			DataManager.get_current_inv().delete_item(item)
			
		add_item(item)

# Añade un item al inventario visual (no al inventario del jugador)
# normalmente el item es añadido con anterioridad.
func add_item(item_data : PHItem):
	get_last_row().add_item(item_data)
	create_row_if_can()
	
func drop_item():
	pass

# Elimina un item directamente
func remove_item(item):
	pass

# Hay slots disponibles? Puede que no existan ya que puede
# que el peso este completado
func has_slots():
	pass

# Crea una fila si es que puede. Esto depende si la ultima
# fila tiene capacidad o no para un item.
func create_row_if_can():
	# Caso no exista un row y caso en el cual el ultimo row este lleno
	if rows.size() < 1 or get_last_row().is_full():
		rows.append(load("res://scenes/hud/inventory/row/Row.tscn").instance())
		$Container/MainColumn.add_child(rows[rows.size() - 1])
	
func get_last_row():
	return rows[rows.size() - 1]
	
func _on_item_added(item):
	add_item(item)
	
func _on_player_shooting(player, direction):
	if not player.has_ammo:
		print("hola")