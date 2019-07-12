extends Node2D

class_name Inventory

var hotbar_row : int = 1
var is_fulled : bool = false

# Contiene instancias de Row.tcn
var rows = []

# Muestra si esta abierto el inventario
var is_inventory_open = false

# num de row y slot seleccionado
var last_selected_slot = [-1,-1]

var current_inv : RPGWeightInventory
# Municion total de la arma actual
var total_ammo = 0

var row_rec = preload("res://scenes/hud/player_menu/inventory/row/Row.tscn")

signal item_added
signal item_removed(row_num, slot_num)
signal inventory_item_selected(item)
signal change_diamond(row)

func _ready():
	DataManager.get_current_inv().connect("item_added", self, "_on_item_added")
	
	PlayerManager.connect("player_shooting", self, "_on_player_shooting")
	
	init_inventory()

func _input(event):
	if event.is_action_pressed("next_hotbar"):
		var next_hotbar = (get_current_row().row_num + 1) % rows.size()
		set_row_diamond_selected(next_hotbar)
		emit_signal("change_diamond", rows[next_hotbar])
	elif event.is_action_pressed("previous_hotbar"):
		var next_hotbar = (get_current_row().row_num - 1) % rows.size()
		set_row_diamond_selected(next_hotbar)
		emit_signal("change_diamond", rows[next_hotbar])
	
# Actualiza el inventario en caso de un cambio
func init_inventory():
	create_row_if_can()
	rows[0].get_node("Diamond/DButton").pressed = true
	
#	print("DataManager.get_current_inv().inv",DataManager.get_current_inv().inv)
	for item in DataManager.get_current_inv().inv:
		add_item(item)

# Añade un item al inventario visual (no al inventario del jugador)
# normalmente el item es añadido con anterioridad.
func add_item(item_data : PHItem):
	var was_added = false
	for row in rows:
		if row.num_items < 5:
			row.add_item(item_data)
			was_added = true
			break
	if not was_added :
		create_row_if_can()
		get_last_row().add_item(item_data)

func update_last_selected_slot(row, slot):
	last_selected_slot = [row, slot]
	var item = rows[last_selected_slot[0]].get_item(last_selected_slot[1])
	emit_signal("inventory_item_selected", item)

func drop_selected_slot():
	if last_selected_slot[0] == -1 : return
	
	var row = rows[last_selected_slot[0]]
	var item = row.remove_slot(last_selected_slot[1], false)
	
	if item == null : return
	
	# Si el equip actual es el item a borrar -> equip = null
	if DataManager.get_current_player_instance().equip == item : DataManager.get_current_player_instance().equip = null
	
	var dropped_item = Factory.ItemInWorldFactory.create_from_item(item)
	
	dropped_item.global_position = PlayerManager.get_current_player().global_position + random_drop_distance(30) # Esto de aqui seria la distancia lejos del player que dropea el item
	
	PlayerManager.get_current_player().get_parent().add_child(dropped_item)
	get_total_ammo()

func set_row_diamond_selected(row):
	unselect_row_diammond()
	rows[row].get_node("Diamond/DButton").pressed = true
	
# Devuelve una posicion alrededor de un determinado radio
func random_drop_distance(radius):
	var x = ( randi() % radius*2 ) - radius # Random desde -radius a +radius
	var y = sqrt(pow(radius,2) - pow(x,2))
	return Vector2(x,y)

func drop_item():
	pass

# Elimina un item directamente
func remove_item(item):
	for row in rows:
		if row.has_item(item):
			row.remove_item(item)
	
# Remover todos las rows (visualmente)
func remove_all_rows():
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
		rows.append(row_rec.instance())
		$Control/Cont/Inventory/HBox/Container/MainColumn.add_child(get_last_row())
		
		get_last_row().connect("item_removed", self, "_on_item_removed", [rows.size() - 1])
		get_last_row().connect("slot_selected", self, "_on_slot_selected")
		get_last_row().connect("row_diamond_pressed", self, "_on_row_diammond_pressed")
		
		# le añadimos un identificador igual a su posición en el array row
		get_last_row().init_row(rows.size() - 1) 

func get_last_row():
	return rows[rows.size() - 1]

# Deselecciona todos los slots con excepciones, por ejemplo:
# no deselecciona los items equipados ni tampoco el ultimo
# item seleccionado.
func unselect_all_slots(exceptions := true):
	for row_i in rows.size():
		for slot in range(5):
			if exceptions and last_selected_slot[0] == row_i and last_selected_slot[1] == slot:
				continue
				
			rows[row_i].get_slot(slot).get_node("Slot").pressed = false

func unselect_row_diammond():
	for row in rows:
		row.get_node("Diamond/DButton").pressed = false

func select_row_diammond(row_num):
	for row in rows:
		if row.row_num == row_num:
			row.get_node("Diamond/DButton").pressed = true
			break

func get_current_row():
	for row in rows:
		if row.get_node("Diamond/DButton").pressed:
			return row

# Devuelve el total de municion que puede ocupar,
# dependiendo de las municiones -para la arma actual- 
# que que hay en el inventario
func get_total_ammo():
	# si el equip es null -> sale de la funcion
	var equip = DataManager.get_current_player_instance().equip
	if equip == null : return
	
	var inv = DataManager.get_current_inv().inv
	total_ammo = 0
	
	for item in inv:
		if item is PHAmmo and equip.ammo_type == item.ammo_type:
			total_ammo += item.ammo_amount
	return total_ammo

func update_info_panel(slot):
	pass

func _on_item_added(item):
	add_item(item)

func _on_slot_selected(row, slot):
	unselect_all_slots()
	update_info_panel(slot)

func _on_player_shooting(player, direction):
	# Verificamos player.equip.current_shot == 0 primero
	# ya que es mas costoso llamar a get_total_ammo 
	if player.data.equip is PHDistanceWeapon and player.data.equip.current_shot == 0:
		# Buscamos en el inventario si hay municion a borrar
		for item in DataManager.get_current_inv().inv:
			if item is PHAmmo and item.ammo_amount == 0:
				remove_item(item)

func _on_item_removed(slot_num, row_num):
	emit_signal("item_removed", row_num, slot_num)
	
func _on_row_diammond_pressed(row, pressed):
	if pressed:
		unselect_row_diammond()
		select_row_diammond(row.row_num)
		emit_signal("change_diamond", row)
		