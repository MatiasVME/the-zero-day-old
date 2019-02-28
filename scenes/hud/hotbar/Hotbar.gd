extends Node2D

onready var hud = get_parent()
var current_item : PHItem
# Items en la hotbar actual
var items = []

var current_hotbar = 0
var current_slot = 0 # No seleccionado aun

signal slot_selected(slot_data)

func _ready():
	select_slot(1)
	
	for i in $Slots.get_child_count():
		var slot = get_node("Slots/Slot" + str(i + 1))
		slot.connect("pressed", self, "_on_slot_pressed", [slot])
		
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

# Seleccionar un slot del 1 al 5
func select_slot(slot : int):
	current_slot = slot
	unselect_all_slots(slot)
	
	var slot_selected = get_node("Slots/Slot" + str(slot))
	slot_selected.pressed = true
	
	current_item = slot_selected.data
	
	if hud.hud_actor:
		hud.hud_actor.data.equip = current_item
	
	var bullet_info = hud.get_node("BulletInfo")
	bullet_info.set_current_equip(current_item)
	
	emit_signal("slot_selected", current_item)

func unselect_all_slots(except):
	for i in $Slots.get_child_count():
		if i != except - 1:
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
	
func _on_slot_pressed(slot):
	select_slot(int(slot.name.substr(slot.name.length() - 1,1)))
	update_hotbar_row(current_hotbar)
	
func _on_item_taken(item):
	update_hotbar_row(current_hotbar)
	select_slot(current_slot)

func _on_item_removed(row_num, slot_num):
	update_hotbar_row(row_num)



