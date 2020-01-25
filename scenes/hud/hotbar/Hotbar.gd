extends Node2D

onready var hud = get_parent()

enum State {
	HOTBAR_0, # Ningún boton seleccionado.
	HOTBAR_1,
	HOTBAR_2,
	HOTBAR_3,
	HOTBAR_4,
	HOTBAR_5
}
var state = State.HOTBAR_0

var current_item : TZDItem
# Items en la hotbar actual
var items := []
# Botones de la hotbar
var hotbar_buttons := []

var current_hotbar := 0

var hotbar_button_group := ButtonGroup.new()

signal slot_selected(slot_data)

func _ready():
	$Slots/Slot1.group = hotbar_button_group
	$Slots/Slot2.group = hotbar_button_group
	$Slots/Slot3.group = hotbar_button_group
	$Slots/Slot4.group = hotbar_button_group
	$Slots/Slot5.group = hotbar_button_group
	
	$Slots/Slot1.connect("pressed", self, "_on_slot_pressed", [State.HOTBAR_1])
	$Slots/Slot2.connect("pressed", self, "_on_slot_pressed", [State.HOTBAR_2])
	$Slots/Slot3.connect("pressed", self, "_on_slot_pressed", [State.HOTBAR_3])
	$Slots/Slot4.connect("pressed", self, "_on_slot_pressed", [State.HOTBAR_4])
	$Slots/Slot5.connect("pressed", self, "_on_slot_pressed", [State.HOTBAR_5])
	
	# Es null cuando no hay ningún slot seleccionado
	hotbar_buttons.append(null) 
	hotbar_buttons.append($Slots/Slot1)
	hotbar_buttons.append($Slots/Slot2)
	hotbar_buttons.append($Slots/Slot3)
	hotbar_buttons.append($Slots/Slot4)
	hotbar_buttons.append($Slots/Slot5)

	hud.connect("ready", self, "_on_hud_ready")

func set_hotbar_actor(actor : GActor):
	if actor is GPlayer:
		actor.connect("item_taken", self, "_on_item_taken")

		actor.data.connect("stamina_changed", self, "_on_stamina_changed")
		actor.data.connect("stamina_max_changed", self, "_on_stamina_max_changed")

	update_hotbar_row(0)
#
## Seleccionar un slot del 1 al 5 o null
func select_slot(slot : int = 0):
	if slot == 0:
		emit_signal("slot_selected", null)
		return

	var slot_selected = get_node("Slots/Slot" + str(slot))

	if slot_selected.pressed != true:
		slot_selected.pressed = false
		unselect_all_slots()
		current_item = null
	else:
		slot_selected.pressed = true
#		unselect_all_slots(slot)
		current_item = slot_selected.data

	var bullet_info = hud.get_node("BulletInfo")
	bullet_info.set_current_equip(current_item)

	state = slot

	emit_signal("slot_selected", current_item)

# Selección el próximo slot, cuando sale del límite 1 o 5
# se vuelve 0 y si esta en 0 (no seleccionado) se selecciona
# 1 o 5 dependiendo si esta invertido o no.
func limited_next_slot(invert := false):
	if state == 0:
		if invert: state = 5
		else: state = 1
	else:
		if invert:
			if (state - 1) % 1 == 0:
				state -= 1
			else:
				state = 0
		else:
			if (state + 1) % 6 != 0:
				state += 1
			else:
				state = 0

	if state != 0:
		# Por algún motivo que desconozco se tiene que presionar
		# el botón por código también.
		get_node("Slots/Slot" + str(state)).pressed = true
	else:
		unselect_all_slots()

	select_slot(state)
	update_hotbar_row(current_hotbar)

func unselect_all_slots(except = -1):
	for i in $Slots.get_child_count():
		if i != except - 1 or except == -1:
			get_node("Slots/Slot" + str(i + 1)).pressed = false

# Cambia de hotbar desde 0 a ..
func update_hotbar_row(row : int):
	if not hud:
		print_debug("HUD not found")
		return

	if not hud.inventory:
		print_debug("not inventory")
		return
	elif hud.inventory and hud.inventory.rows.size() < 1:
		print_debug("inventory and inventory.rows < 1")
		return

	current_hotbar = row

	items = []
	for i in range(0, 5):
		var item = hud.inventory.rows[row].get_item(i)

		items.append(item)

		if item:
			get_node("Slots/Slot" + str(i + 1) + "/ItemSprite").texture = load(item.texture_path)
			get_node("Slots/Slot" + str(i + 1)).data = item
		else:
			get_node("Slots/Slot" + str(i + 1) + "/ItemSprite").texture = null
			get_node("Slots/Slot" + str(i + 1)).data = null

# Slot es un texturebutton pero se le extrae el nombre
func _on_slot_pressed(button_pressed, slot):
	select_slot(slot)
	update_hotbar_row(current_hotbar)

func _on_change_diamond(row):
	update_hotbar_row(row.row_num)

func _on_item_taken(item):
	update_hotbar_row(current_hotbar)
	select_slot(state)

func _on_item_removed():
	update_hotbar_row(current_hotbar)

func _on_stamina_changed(new_stamina_value):
	$HotbarBG/Stamina.value = new_stamina_value

func _on_stamina_max_changed(new_stamina_max_value):
	$HotbarBG/Stamina.max_value = new_stamina_max_value

func _on_hud_ready():
	if not hud.inventory:
		print_debug("Inventory not found xd")
		return

	update_hotbar_row(0)

	# Conectamos la hotbar al inventario para escuchar cuando
	# hay un item es removido o etc.
	DataManager.get_current_inv().connect("item_removed", self, "_on_item_removed")
	# Conectamos la hotbar al inventario para escuchar cuando
	# se cambia de hotbar.
	hud.inventory.connect("change_diamond", self, "_on_change_diamond")	

