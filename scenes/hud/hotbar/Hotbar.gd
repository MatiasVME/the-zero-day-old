extends Node2D

onready var hud = get_parent()
onready var inventory = hud.get_node("Inventory")

var current_item : PHItem
# Items en la hotbar actual
var items = []

var current_hotbar = 0
var current_slot = 0 # No seleccionado aun

signal slot_selected(slot_data)

func _ready():
	for i in $Slots.get_child_count():
		var slot = get_node("Slots/Slot" + str(i + 1))
		var slot_num = int(slot.name.substr(slot.name.length() - 1,1))
		slot.connect("toggled", self, "_on_slot_toggled", [slot_num])
	
	if not inventory:
		print("Inventory not found")
		return
	
	update_hotbar_row(0)
	
	# Conectamos la hotbar al inventario para escuchar cuando
	# hay un item es removido o etc.
	hud.get_node("Inventory").connect("item_removed", self, "_on_item_removed")
	# Conectamos la hotbar al inventario para escuchar cuando
	# se cambia de hotbar.
	hud.get_node("Inventory").connect("change_diamond", self, "_on_change_diamond")
	
func set_hotbar_actor(actor : GActor):
	if actor is GPlayer:
		actor.connect("item_taken", self, "_on_item_taken")
	
	update_hotbar_row(0)
	
# Seleccionar un slot del 1 al 5 o null
func select_slot(slot : int = 0):
	if slot == 0:
		return
	
	var slot_selected = get_node("Slots/Slot" + str(slot))
	
	if slot_selected.pressed != true:
		slot_selected.pressed = false
		unselect_all_slots()
		current_item = null
	else:
		slot_selected.pressed = true
		unselect_all_slots(slot)
		current_item = slot_selected.data
	
	if hud.hud_actor:
		hud.hud_actor.data.equip = current_item
	
	var bullet_info = hud.get_node("BulletInfo")
	bullet_info.set_current_equip(current_item)
	
	current_slot = slot
	
	emit_signal("slot_selected", current_item)

# Selección el próximo slot, cuando sale del límite 1 o 5
# se vuelve 0 y si esta en 0 (no seleccionado) se selecciona
# 1 o 5 dependiendo si esta invertido o no.
func limited_next_slot(invert := false):
	if current_slot == 0:
		if invert: current_slot = 5
		else: current_slot = 1
	else:
		if invert:
			if (current_slot - 1) % 1 == 0:
				current_slot -= 1
			else:
				current_slot = 0
		else:
			if (current_slot + 1) % 6 != 0:
				current_slot += 1
			else:
				current_slot = 0
	
	if current_slot != 0:
		# Por algún motivo que desconozco se tiene que presionar
		# el botón por código también.
		get_node("Slots/Slot"+str(current_slot)).pressed = true
	else:
		unselect_all_slots()
		
	select_slot(current_slot)
	update_hotbar_row(current_hotbar)
	
func unselect_all_slots(except = -1):
	for i in $Slots.get_child_count():
		if i != except - 1 or except == -1:
			get_node("Slots/Slot" + str(i + 1)).pressed = false

# Cambia de hotbar desde 0 a ..
func update_hotbar_row(row : int):
	if not hud:
		print("HUD not found")
		return
		
	var inventory = hud.get_node("Inventory")
	
	if not inventory:
		print("not inventory")
		return
	elif inventory and inventory.rows.size() < 1:
		print("inventory and inventory.rows < 1")
		return
	
	current_hotbar = row
	
	items = []
	for i in range(0, 5):
		var item = inventory.rows[row].get_item(i)
		
		items.append(item)
		
		if item:
			get_node("Slots/Slot" + str(i + 1) + "/ItemSprite").texture = load(item.texture_path)
			get_node("Slots/Slot" + str(i + 1)).data = item
		else:
			get_node("Slots/Slot" + str(i + 1) + "/ItemSprite").texture = null
			get_node("Slots/Slot" + str(i + 1)).data = null
	
# Slot es un texturebutton pero se le extrae el nombre
func _on_slot_toggled(button_pressed, slot):
	select_slot(slot)
	update_hotbar_row(current_hotbar)
	
func _on_change_diamond(row):
	update_hotbar_row(row.row_num)
	
func _on_item_taken(item):
	update_hotbar_row(current_hotbar)
	select_slot(current_slot)

func _on_item_removed(row_num, slot_num):
	update_hotbar_row(current_hotbar)

