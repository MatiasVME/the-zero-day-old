extends Node2D

var sell_normal = preload("res://scenes/buttons/sell/SellNormal.png")
var sell_pressed = preload("res://scenes/buttons/sell/SellPressed.png")

var buy_normal = preload("res://scenes/buttons/buy/BuyNormal.png")
var buy_pressed = preload("res://scenes/buttons/buy/BuyPressed.png")
var buy_disabled = preload("res://scenes/buttons/buy/BuyDisabled.png")

enum BuySellState {NONE, BUY, SELL}
var buysell_state = BuySellState.NONE

var item_selected

func _ready():
	MusicManager.play(MusicManager.Music.SHOP_THEME)
	
	$PlayerInv.add_inventory(DataManager.get_current_inv())
	$ShopInv.add_inventory(DataManager.get_shop_inv()) ## se debe setear inventario
	
	# Temp
	$ShopInv.add_item_to_gui(Factory.ItemFactory.create_rand_distance_weapon())
	$ShopInv.add_item_to_gui(Factory.ItemFactory.create_rand_distance_weapon(50, 2, 50, null, 50))
	$ShopInv.add_item_to_gui(Factory.ItemFactory.create_rand_distance_weapon(100, 3, 100, null, 100))
	
#	for item in Factory.ItemFactory.create_rand_item_pack_for_shop():
#		$ShopInv.add_item_to_gui(item)
		
	$ShopInv.connect("slot_selected", self, "_on_shop_slot_selected")
	$PlayerInv.connect("slot_selected", self, "_on_player_slot_selected")
	
	$BuySell.hide()

func can_buy(item : TZDItem):
	if item.buy_price <= DataManager.data_user["Money"]:
		return true
	return false

func _on_shop_slot_selected(_slot : InventorySlot):
	item_selected = _slot.data
#	print_debug("item_selected", item_selected)
	
	$InfoItems.update_panel_item_info(_slot.data)
	$PlayerInv.unselect_all_items()
	
	$BuySell.texture_normal = buy_normal
	$BuySell.texture_pressed = buy_pressed
	$BuySell.texture_disabled = buy_disabled
	
	if can_buy(item_selected):
		$BuySell.show()
		$BuySell.disabled = false
		buysell_state = BuySellState.BUY
	else:
		$BuySell.disabled = true
		buysell_state = BuySellState.NONE
	
func _on_player_slot_selected(_slot : InventorySlot):
	item_selected = _slot.data
	buysell_state = BuySellState.SELL
	
	$InfoItems.update_panel_item_info(_slot.data)
	$ShopInv.unselect_all_items()
	
	$BuySell.texture_normal = sell_normal
	$BuySell.texture_pressed = sell_pressed
	
func _on_BuySell_pressed():
	var item = $ShopInv.take_item_to_gui(item_selected)
	
	if not item: print_debug(item); return
	
	if buysell_state == BuySellState.BUY:
		$PlayerInv.add_item_to_gui(item)
		DataManager.data_user["Money"] -= item.sell_price
	elif buysell_state == BuySellState.SELL:
		$ShopInv.add_item_to_gui(item)
		DataManager.data_user["Money"] += item.sell_price
	else:
		pass
		
