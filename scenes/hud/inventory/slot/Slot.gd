extends Control

class_name InventorySlot

var data : PHItem
var slot_num = -1

signal selected(slot)

func add_item(item_data : PHItem):
	data = item_data
	
	$Slot/Item.texture = load(data.get_texture_path())
	
func has_item():
	if data:
		return true
	return false

func _on_Slot_pressed():
	emit_signal("selected", self)
