extends ScrollContainer

func _ready():
	get_parent().connect("inventory_item_selected", self, "_on_inventory_item_selected")
	$PanelsColumn/ItemAccions/Accions/AccionRow/Drop/DropButton.connect("button_up", self, "_on_drop_button_up")
	reset_panel_item_info()
	
func update_panel_item_info(item):
	# Si es un item activa el info panel
	if item is TZDItem:
		$PanelsColumn/ItemData.show()
		$PanelsColumn/ItemAccions/Accions.show()
		$PanelsColumn/ItemName.show()

		$PanelsColumn/ItemName/BackPanel/ItemName.text = item.item_name
		$PanelsColumn/ItemData/Data/DataRow/ItemIcon/Icon.texture = load(item.texture_path)
	else:
		reset_panel_item_info()

	hide_all_icons()

	# Se muestran las caracteristicas dependiendo que item es.
	#

	if item is TZDItem:
		$PanelsColumn/ItemData/Data/DataRow/Grid/Buy.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/Buy.set_text("-" + str(item.buy_price))

		$PanelsColumn/ItemData/Data/DataRow/Grid/Sell.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/Sell.set_text("+" + str(item.sell_price))

		$PanelsColumn/ItemData/Data/DataRow/Grid/Weight.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/Weight.set_text(str(item.weight))

	if item is PHEquipment:
		$PanelsColumn/ItemData/Data/DataRow/Grid/Type.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/Type.set_text(item.get_str_equipment_type())

	if item is PHWeapon:
		$PanelsColumn/ItemData/Data/DataRow/Grid/TimeToNextAction.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/TimeToNextAction.set_text(str(item.time_to_next_action))

		$PanelsColumn/ItemData/Data/DataRow/Grid/Damage.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/Damage.set_text(str(item.damage))

	if item is PHDistanceWeapon:
		$PanelsColumn/ItemData/Data/DataRow/Grid/WeaponCapacity.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/WeaponCapacity.set_text(str(item.weapon_capacity))

		$PanelsColumn/ItemData/Data/DataRow/Grid/TimeToReload.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/TimeToReload.set_text(str(item.time_to_reload))

		$PanelsColumn/ItemData/Data/DataRow/Grid/RequiresAmmo.show()
		if item.requires_ammo : $PanelsColumn/ItemData/Data/DataRow/Grid/RequiresAmmo.set_text("Y")
		else: $PanelsColumn/ItemData/Data/DataRow/Grid/RequiresAmmo.set_text("N")

	if item is PHDefence:
		$PanelsColumn/ItemData/Data/DataRow/Grid/Defence.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/Defence.set_text(str(item.defence))
	
	if item is TZDAmmo:
		$PanelsColumn/ItemData/Data/DataRow/Grid/AmmoAmount.show()
		$PanelsColumn/ItemData/Data/DataRow/Grid/AmmoAmount.set_text(str(item.ammo_amount))
	
func hide_all_icons():
	$PanelsColumn/ItemData/Data/DataRow/Grid/Buy.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/AmmoAmount.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Attack.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Damage.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Defense.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Heal.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/RequiresAmmo.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Sell.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/TimeToNextAction.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/TimeToReload.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Type.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/WeaponCapacity.hide()
	$PanelsColumn/ItemData/Data/DataRow/Grid/Weight.hide()

func reset_panel_item_info():
	$PanelsColumn/ItemName.hide()
	$PanelsColumn/ItemData.hide()
	$PanelsColumn/ItemAccions.hide()

#func reset_icon_texture():
#	$PanelsColumn/ItemData/Data/DataRow/ItemIcon/Icon.texture = default_icon_texture

func _on_inventory_item_selected(item):
	if not item : return
	update_panel_item_info(item)

func _on_drop_button_up():
	get_parent().drop_selected_slot()
	reset_panel_item_info()