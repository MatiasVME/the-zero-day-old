extends Node2D

func _ready():
	select_slot(1)
	
	for i in $Slots.get_child_count():
		var slot = get_node("Slots/Slot" + str(i + 1))
		slot.connect("pressed", self, "_on_slot_pressed", [slot])

func _input(event):
	if event.is_action_pressed("hotbar1"):
		select_slot(1)
	elif event.is_action_pressed("hotbar2"):
		select_slot(2)
	elif event.is_action_pressed("hotbar3"):
		select_slot(3)
	elif event.is_action_pressed("hotbar4"):
		select_slot(4)
	elif event.is_action_pressed("hotbar5"):
		select_slot(5)

# Seleccionar un slot del 1 al 5
func select_slot(slot : int):
	unselect_all_slots(slot)
	get_node("Slots/Slot" + str(slot)).pressed = true

func unselect_all_slots(except):
	for i in $Slots.get_child_count():
		if i != except - 1:
			get_node("Slots/Slot" + str(i + 1)).pressed = false
	
func _on_slot_pressed(slot):
	select_slot(int(slot.name.substr(slot.name.length() - 1,1)))
	