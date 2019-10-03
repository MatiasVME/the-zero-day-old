extends HBoxContainer

class_name InventoryRow

var inventory

var row_num = -1
var num_items = 0

signal item_removed(slot_num)
signal slot_selected(row, slot)
signal row_diamond_pressed(row, pressed)

func _ready():
	DataManager.get_current_inv().connect("item_to_be_removed", self, "_on_item_to_be_removed")

# Añade un identificador y conecta cada slot con "update_last_selected_slot"
func init_row(row_num):
	inventory = get_parent().get_owner()
	
	self.row_num = row_num
	
	var Slots = $Slots.get_children()
	for i in range(Slots.size()):
		Slots[i].slot_num = i # Se le añade un identificador a cada slot
		Slots[i].get_node("Slot").connect("button_up", inventory, "update_last_selected_slot", [row_num, i])
	
		# Se connectan los slots
		# TODO: Hay que desconectarlos cuando no se esten usando
		Slots[i].connect("selected", self, "_on_slot_selected")
	
	get_node("Diamond/DButton").connect("toggled", self, "_on_DButton_toggled")
	
func add_item(item_data : TZDItem):
	for slot in $Slots.get_children():
		if not slot.has_item():
			slot.add_item(item_data)
			num_items += 1
			break

# Recupera solo el Slot
func get_slot(slot_id : int):
	return get_node("Slots/Slot" + str(slot_id + 1))
	
func get_item(item : int) -> TZDItem:
	return get_slot(item).data

# Ve si estan todos los slots ocupados o no
func is_full():
	for Slot in $Slots.get_children():
		if not Slot.has_item():
			return false
	return true
	
func has_item(item : TZDItem):
	for slot in $Slots.get_children():
		if slot.data == item:
			return true
			
	return false

# Borra el item del parámetro (Borra visualmente no lo borra del inventario)
# Devuelve el slot del item que se a borrado
func clear_item_from_slot(item : TZDItem):
	# Sirve para almacenar el slot que se a borrado
	var slot_num := 0
	
	# Buscamos el slot para eliminarlo
	for slot in $Slots.get_children():
		if slot.data == item:
			slot.data = null
			slot.get_node("Slot/Item").texture = null
			break
		
		slot_num += 1
	
	return slot_num

func remove_item(item : TZDItem):
	var slot_num = clear_item_from_slot(item)
	
	# Borramos el item del inventario asumiendo que
	# existe en el
	DataManager.get_current_inv().delete_item(item)
	num_items -= 1
	emit_signal("item_removed", slot_num)
	
# Remueve el item del slot, free_item controla si el item es liberado del tree
func remove_slot(slot_num : int, free_item = true):
	var slot = get_slot(slot_num)
	var item : TZDItem = slot.data
	slot.data = null
	slot.get_node("Slot/Item").texture = null
	
	if item == null : return 
	
	DataManager.get_current_inv().delete_item(item, free_item)
	num_items -= 1
	emit_signal("item_removed", slot_num)
	
	if not free_item : return item

func _on_slot_selected(slot):
	emit_signal("slot_selected", self, slot)

func _on_DButton_toggled(button_pressed):
	emit_signal("row_diamond_pressed", self, button_pressed)

func _on_item_to_be_removed(item : TZDItem):
	clear_item_from_slot(item)