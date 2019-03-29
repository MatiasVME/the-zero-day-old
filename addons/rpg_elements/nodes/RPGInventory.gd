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

extends "RPGElement.gd"

class_name RPGInventory, "../icons/RPGInventory.png"

var inv = [] setget , get_inv
export (String) var inv_name = "" setget set_inv_name, get_inv_name

signal item_added(item)
signal item_removed
signal item_taken(item)

# Métodos Públicos y Setters/Getters
#

func get_inv():
	return inv

# Añade el item sin pensarlo mucho
func add_item(item):
	if typeof(inv) == TYPE_ARRAY:
		inv.append(item)
		emit_signal("item_added", item)
	else:
		.debug("Por algún motivo ", inv, " no es un array.")

# Se le pasa el item para ser retirado del inventario
# y la cantidad. Si la cantidad de items retirados es
# menor que la cantidad de items que tiene el array,
# devuelve un item nuevo con la catidad indicada.
func take_item(item, amount = 1):
	var item_found
	
	# Buscar el item en el invetario y devuelve el indice
	var item_index = inv.find(item)
	
	# Si no lo encuentra entonces dice un mensaje de
	# que no se a encontrado.
	if item_index == -1:
		.debug("No se a encontrado el item: ", item)
		return
	
	# Almacena el item para luego retornarlo (mas adelante)
	item_found = inv[item_index]
	
	# Ver la cantidad deseada de items y ver que hacer
	# en los distintos casos
	if item_found.amount == amount:
		inv.remove(item_index)
		return item_found
	elif amount > item_found.amount:
		.debug("La cantidad de items a retirar es superior a la cantidad de items encontrados en el inventario")
		return
	elif amount < item_found.amount:
		item_found.amount -= amount
		# Creamos un nuevo item para devolverlo
		var new_item = item.duplicate()
		new_item.amount = amount
		# No removemos ningún item ya que quedan algunos
		# items en el inventario, porque:
		# amount < item_found.amount
		return new_item

# TODO: Toma el item del inventario (lo remueve del inventario y lo
# retorna) TODO (NO USE)
func take_item_by_name(item_name, amount = 1):
	var items_to_taken = []
	
	# Si la cantidad de items es 1 entonces busca
	# el primer item que encuentra para
	if amount == 1:
		var item = search_all_items_with_the_name(item_name)
		
		if item != null:
			items_to_taken.append(item)
		else:
			.debug("No sea a encontrado el item para take_item()")
	else:
		items_to_taken = search_all_items_with_the_name(item_name)
	
	if items_to_taken.size() == 0:
		return
	
	var items_ids = []
	var amount_count = 0
	
	for i in range(0, items_to_taken.size()):
		if items_to_taken[i].item_name == item_name:
			items_ids.append(items_to_taken[i].get_instance_ID())
			
			if items_to_taken[i].amount > amount:
				items_to_taken[i].amount -= amount
				
				# Retorna un nuevo item sacado de la pila de items
				# no elimina el item ya que el item actual contiene
				# mas items del mismo tipo que los que se solicitaron
				# sacar.
				var new_item = items_to_taken[i].duplicate()
				new_item.amount = amount
				
				return new_item
			elif items_to_taken[i].amout == amount:
				pass
	pass

# Retorna el primer item o pila de items que encuentra con 
# el nombre indicado
# NEEDTEST
func search_item_by_name(item_name):
	for i in range(0, inv.size()):
		if inv[i].item_name == item_name:
			return inv[i]
			
	.debug("search_item_by_name() No a encontrado el item.")

# Busca todos los items con el nombre item_name y lo
# devuelve
# NEEDTEST
func search_all_items_with_the_name(item_name):
	var all_items = []
	
	for i in range(0, inv.size()):
		if inv[i].item_name == item_name:
			all_items.append(inv[i])
	
	return all_items

# Borra totalmente un item
# NEEDTEST
func delete_item(item, free_item = true):
	if inv.has(item):
		inv.erase(item)
		#if free_item : item.queue_free()
		emit_signal("item_removed")
		return true
		
	return false

func remove_all_items():
	for i in range(0, inv.size()):
		inv[i].queue_free()
	
	inv = []
	
func set_inv_name(_inv_name):
	inv_name = _inv_name
	
func get_inv_name():
	return inv_name

# Devuelve -este- inventario en forma de diccionario.
func inv2dict():
	var dict_inv = []
	
	var i = 0
	while i < inv.size():
		dict_inv.append(gdc2gd(inst2dict(inv[i]))) # OLD
#		dict_inv.append(inst2dict(inv[i])) # NEW
		i += 1
	
	var dict = gdc2gd(inst2dict(self)) # OLD
#	var dict = inst2dict(self) # NEW
	dict["inv"] = dict_inv
	
	return dict

# Recibe un diccionario de inventario y devuelve una 
# instancia de inventario.
func dict2inv(_dict):
	var inst_items = []
	
	# Convertir los items a instancia y guardarlos
	# en inst_items
	var i = 0
	while i < _dict["inv"].size():
		inst_items.append(dict2inst(_dict["inv"][i]))
		i += 1
	
	# Borrar los item del diccionario
	var inv_dict = _dict["inv"]
	_dict["inv"] = []
	
	# Convertir el diccionario principal a instancia
	var inst_inv = dict2inst(_dict)
	
	# Volver el inventario al diccionario _dict
	_dict["inv"] = inv_dict
	
	# Añadir los items a la instancia principal
	i = 0
	while i < inst_items.size():
		inst_inv.add_item(inst_items[i])
		i += 1
	
	return inst_inv
	
# Métodos "Privados"
#
