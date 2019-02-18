extends Control

var data : PHItem

func add_item(item_data : PHItem):
	data = item_data
	
	$Slot/Item.texture = load(data.get_texture_path())
	
func has_item():
	if data:
		return true
	return false
