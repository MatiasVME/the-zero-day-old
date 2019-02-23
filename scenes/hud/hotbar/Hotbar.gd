extends Node2D

onready var hud = get_parent()
# Items en la hotbar actual
var items = []

var current_hotbar = 0

func _ready():
	select_slot(1)
	
	for i in $Slots.get_child_count():
		var slot = get_node("Slots/Slot" + str(i + 1))
		slot.connect("pressed", self, "_on_slot_pressed", [slot])
		
	update_hotbar_row(0)

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
	unselect_all_slots(slot)
	get_node("Slots/Slot" + str(slot)).pressed = true

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
	
	items.clear()
	for i in range(0, 5):
		var item = inventory.rows[row].get_item(i)
		items.append(item)
		
		if item:
			get_node("Slots/Slot" + str(i + 1) + "/ItemSprite").texture = load(item.texture_path)
		else:
			get_node("Slots/Slot" + str(i + 1) + "/ItemSprite").texture = null
		
func _on_slot_pressed(slot):
	select_slot(int(slot.name.substr(slot.name.length() - 1,1)))
	update_hotbar_row(current_hotbar)
	
func _on_item_taken(item):
	update_hotbar_row(current_hotbar)





