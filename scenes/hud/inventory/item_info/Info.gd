extends ScrollContainer

var default_icon_texture = preload("res://icon.png")

func _ready():
	get_parent().connect("inventory_item_selected", self, "_on_inventory_item_selected")
	$PanelsColumn/ItemAccions/Accions/AccionRow/Drop/DropButton.connect("button_up", self, "_on_drop_button_up")

func update_panel_item_info(item):
	reset_panel_item_info()
	var texture = load(item.get_texture_path())
	if texture :
		$PanelsColumn/ItemData/Data/DataRow/ItemIcon/TextureRect.texture = texture
	else : 
		reset_icon_texture()
	
	update_prices(item)
	
	if item is PHAmmo:
		$PanelsColumn/ItemData/Data/DataRow/ItemConsumableProp/Amount.set_icon(texture)
		$PanelsColumn/ItemData/Data/DataRow/ItemConsumableProp/Amount.set_text("x" + String(item.ammo_amount))

func update_prices(item):
	$PanelsColumn/ItemData/Data/DataRow/ItemBuySell/Buy.set_text("-" + String(item.buy_price))
	$PanelsColumn/ItemData/Data/DataRow/ItemBuySell/Sell.set_text("+" + String(item.sell_price))

func reset_panel_item_info():
	reset_icon_texture()
	$PanelsColumn/ItemData/Data/DataRow/ItemBuySell/Buy.set_text("-0")
	$PanelsColumn/ItemData/Data/DataRow/ItemBuySell/Sell.set_text("+0")
	$PanelsColumn/ItemData/Data/DataRow/ItemConsumableProp/Amount.set_icon(default_icon_texture)
	$PanelsColumn/ItemData/Data/DataRow/ItemConsumableProp/Amount.set_text("x0")

func reset_icon_texture():
	$PanelsColumn/ItemData/Data/DataRow/ItemIcon/TextureRect.texture = default_icon_texture

func _on_inventory_item_selected(item):
	if item == null : return
	update_panel_item_info(item)

func _on_drop_button_up():
	get_parent().drop_selected_slot()
	reset_panel_item_info()