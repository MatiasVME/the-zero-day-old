# MIT License
#
# Copyright (c) 2018 - 2019 Matías Muñoz Espinoza
# Copyright (c) 2018 Jovani Pérez
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends RPGInventory

class_name RPGWeightInventory, "../icons/RPGWeightInventory.png"

const MIN_WEIGHT_INV = 4

export (float) var max_weight = 20 setget set_max_weight, get_max_weight
var current_weight = 0 setget , get_current_weight
var inventory_full = false setget , is_full

signal fulled

func _ready():
	if debug:
		connect("fulled", self, "_on_fulled")

# Métodos Públicos y Setters/Getters
#

func add_item(item : RPGItem) -> bool:
	# Esto se deja por si el inventario esta vacio y
	# el current_weight a cambiado.
	if inv.size() == 0:
		current_weight = 0
	
	if item == null:
		return false
	
	if can_add_item(item):
		var total_weight = (current_weight + item.weight) * item.amount
	
		current_weight += item.weight * item.amount
		.add_item(item)
		
		if total_weight == max_weight:
			inventory_full = true
			emit_signal("fulled")
		
		return true
	else:
		return false

# Puede ser añadido el item, dependiendo de su peso?
func can_add_item(item):
	if (item.weight + current_weight) * item.amount <= max_weight:
		return true
	return false

# NEEDTEST
func take_item_by_id(id):
	for i in range(0, inv.size()):
		if inv[i].get_instance_ID() == id:
			current_weight -= inv[i].weight * inv[i].amount
			break
	
	return .take_item_by_id(id)

func take_item(item, amount = 1):
	var item_taken = .take_item(item, amount)
	
	if item_taken:
		current_weight -= item.weight * item.amount
		return item_taken
	else:
		return

# Borra un item devuelve si lo elimina o no
func delete_item(item, free_item = true):
	if inv.has(item):
		current_weight -= item.weight * item.amount
		return .delete_item(item, free_item)

func add_max_weight(weight):
	max_weight += weight
	
func remove_max_weight(weight):
	if max_weight - weight >= MIN_WEIGHT_INV:
		max_weight -= weight

func remove_all_items():
	.remove_all_items()
	current_weight = 0

func get_current_weight():
	return current_weight

func is_full():
	return inventory_full

func set_max_weight(_max_weight):
	if _max_weight > current_weight:
		max_weight = _max_weight
		return true
	else:
		.debug("No se pude cambiar el tamaño del inventario.")
		return false

func get_max_weight():
	return max_weight

func stack_all_items():
	# Uso while ya que el for in range al parecer evalua
	# una sola vez la condición, lo siguiente no me
	# funcionó: for i in range(0, inv.size()):
	
	var i = 0
	while i < inv.size():
		var items_found = .search_all_items_with_the_name(inv[i].item_name)
		
		if items_found.size() > 1:
			for j in range(1, items_found.size()):
				inv[i].amount += items_found[j].amount
				inv.remove(inv.find(items_found[j]))
		
		i += 1
	
# Métodos "Privados"
#

# Eventos
#

func _on_fulled():
	.debug("Full Inventory: ", inv_name)