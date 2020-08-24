extends Control

class_name InventorySlot

export (bool) var is_disabled = false

var data : TZDItem
var slot_num = -1

signal selected(slot)

func _ready():
	$Slot.disabled = is_disabled

func add_item(item_data : TZDItem):
	data = item_data
	
	if is_instance_valid(data):
		# TODO: Preferir preload en ves de load
		$Slot/Item.texture = load(data.get_texture_path())
	else:
		print_debug(data, " No es una instancia valida")
	
func has_item():
	if data:
		return true
	return false

func _on_Slot_pressed():
	if $Slot.pressed:
		emit_signal("selected", self)
	else:
		emit_signal("selected", null)
