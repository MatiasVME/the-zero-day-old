extends HBoxContainer

var row_num = -1
var num_items = 0

signal item_removed(slot_num)

# Añade un identificador y conecta cada slot con "update_last_selected_slot"
func init_row(row_num):
	self.row_num = row_num
	var Slots = $Slots.get_children()
	for i in range(Slots.size()):
		Slots[i].slot_num = i	# Se le añade un identificador a cada slot
		var hud_inv = get_parent().get_parent().get_parent() # Por ahora la unica forma de obtener el hud desde aquí
		Slots[i].get_node("Slot").connect("button_up", hud_inv, "update_last_selected_slot", [row_num, i])

func add_item(item_data : PHItem):
	for slot in $Slots.get_children():
		if not slot.has_item():
			slot.add_item(item_data)
			num_items += 1
			break

# recupera solo el Slot
func get_slot(slot_id : int):
	return get_node("Slots/Slot" + str(slot_id + 1))
	
func get_item(item : int) -> PHItem:
	return get_slot(item).data

# Ve si estan todos los slots ocupados o no
func is_full():
	for Slot in $Slots.get_children():
		if not Slot.has_item():
			return false
	return true
	
func has_item(item : PHItem):
	for slot in $Slots.get_children():
		if slot.data == item:
			return true
			
	return false
	
func remove_item(item : PHItem):
	# Sirve para almacenar el slot que se a borrado
	var slot_num : int = 0
	
	# Buscamos el slot para eliminarlo
	for slot in $Slots.get_children():
		if slot.data == item:
			slot.data = null
			slot.get_node("Slot/Item").texture = null
			break
		
		slot_num += 1
		
	# Borramos el item del inventario asumiendo que
	# existe en el
	DataManager.get_current_inv().delete_item(item)
	num_items -= 1
	emit_signal("item_removed", slot_num)
	
# Remueve el item del slot, free_item controla si el item es liberado del tree
func remove_slot(slot_num : int, free_item = true):
	var slot = get_slot(slot_num)
	var item : PHItem = slot.data
	slot.data = null
	slot.get_node("Slot/Item").texture = null
	
	if item == null : return 
	
	DataManager.get_current_inv().delete_item(item, free_item)
	num_items -= 1
	emit_signal("item_removed", slot_num)
	
	if not free_item : return item
	
	
