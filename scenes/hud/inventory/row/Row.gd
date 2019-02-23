extends HBoxContainer

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