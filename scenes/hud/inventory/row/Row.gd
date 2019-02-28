extends HBoxContainer

signal item_removed(slot_num)

func add_item(item_data : PHItem):
	for slot in $Slots.get_children():
		if not slot.has_item():
			slot.add_item(item_data)
			break

func get_item(item : int) -> PHItem:
	return get_node("Slots/Slot" + str(item + 1)).data

# Ve si estan todos los slots ocupados o no
func is_full():
	if $Slots/Slot5.has_item():
		return true
	return false
	
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
	
	emit_signal("item_removed", slot_num)