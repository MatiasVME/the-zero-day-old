extends Node2D

export (Curve) var damage_increment

func _ready():
	MusicManager.play(MusicManager.Music.SHOP_THEME)
	
	$PlayerInv.add_inventory(DataManager.get_current_inv())
	
	# Temp
	$ShopInv.add_item_to_gui(Factory.ItemFactory.create_rand_distance_weapon())
	$ShopInv.add_item_to_gui(Factory.ItemFactory.create_rand_distance_weapon(50, 2, 50, null, 50))
	$ShopInv.add_item_to_gui(Factory.ItemFactory.create_rand_distance_weapon(100, 3, 100, null, 100))
	
#	for item in Factory.ItemFactory.create_rand_item_pack_for_shop():
#		$ShopInv.add_item_to_gui(item)

	print_debug(smoothstep(5, 100, 50))
		
	$ShopInv.connect("slot_selected", self, "_on_shop_slot_selected")
	$PlayerInv.connect("slot_selected", self, "_on_player_slot_selected")

func can_buy(item : TZDItem):
	
	return false

func _on_shop_slot_selected(_slot : InventorySlot):
	$InfoItems.update_panel_item_info(_slot.data)
	$PlayerInv.unselect_all_items()
	
	if can_buy(_slot.data):
		pass
	else:
		$BuySell.hide()
	
func _on_player_slot_selected(_slot : InventorySlot):
	$InfoItems.update_panel_item_info(_slot.data)
	$ShopInv.unselect_all_items()
	