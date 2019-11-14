extends Panel

# Recurso slot
onready var rec_slot = preload("res://scenes/hud/player_menu/inventory/slot/Slot.tscn")

var rpg_weight_inv : RPGWeightInventory

signal slot_selected(slot)

func add_inventory(inv : RPGWeightInventory):
	rpg_weight_inv = inv
	
	add_items_to_gui()
	
func add_items_to_gui():
	for item in rpg_weight_inv.inv:
		add_item_to_gui(item)

func take_item_to_gui(item : TZDItem):
	print_debug("hola", item.get_name() )
	
	for slot in $Scroll/Grid.get_children():
		if slot.data == item:
			$Scroll/Grid.remove_child(slot)
			print_debug("take_item!!")
			return rpg_weight_inv.take_item(item)
			
func add_item_to_gui(item : TZDItem):
	var slot = rec_slot.instance()
	slot.add_item(item)
	
	slot.connect("selected", self, "_on_slot_selected")
	
	$Scroll/Grid.add_child(slot)

# Deselecciona todos los items
func unselect_all_items():
	for item in $Scroll/Grid.get_children():
		item.get_node("Slot").pressed = false

# El item es un slot.tscn de inventario
func _on_slot_selected(_item : InventorySlot):
	for item in $Scroll/Grid.get_children():
		if item != _item:
			item.get_node("Slot").pressed = false
	
	emit_signal("slot_selected", _item)
	