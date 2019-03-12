extends Node2D

onready var hud = get_parent()
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
		
	update_hotbar_row(0)
	
	# Conectamos la hotbar al inventario para escuchar cuando
	# hay un item es removido o etc.
	hud.get_node("Inventory").connect("item_removed", self, "_on_item_removed")

func _input(event):
	if event.is_action_pressed("hotbar1"):
		select_slot(1)
	elif event.is_action_pressed("hotbar2"):
		select_slot(2)
	elif event.is_action_pressed("hotbar3"):
		select_slot(3)
	elif event.is_action_pressed("hotbar4"):
		select_slot(4)
	elif event.is_action_pressed("hotbar5"):
		select_slot(5)

func set_hotbar_actor(actor : GActor):
	if actor is GPlayer:
		actor.connect("item_taken", self, "_on_item_taken")

# Seleccionar un slot del 1 al 5 o null
func select_slot(slot : int):
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
	
	emit_signal("slot_selected", current_item)
	
	current_slot = slot

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
	
	if inventory and inventory.rows.size() < 1:
		print("inventory and inventory.rows < 1")
		return
	
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
		
func _on_item_taken(item):
	update_hotbar_row(current_hotbar)
	select_slot(current_slot)

func _on_item_removed(row_num, slot_num):
	update_hotbar_row(0)
	# 0 para que siempre se quede en el primer row



