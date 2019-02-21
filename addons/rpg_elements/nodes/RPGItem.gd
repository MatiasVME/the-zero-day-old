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
class_name RPGItem, "../icons/RPGItem.png"

export (String) var item_name = "" setget set_item_name, get_item_name
# Descripción
export (String) var desc = "" setget set_desc, get_desc
export (int) var amount = 1
# Precio de compra de un item
export (int) var buy_price = 100 setget set_buy_price, get_buy_price
# Precio de venta de un item
export (int) var sell_price = 50 setget set_sell_price, get_sell_price
# Por si tiene alguna data adiccional
var extra_data setget set_extra_data, get_extra_data
# Imagen del item
var texture_path setget set_texture_path, get_texture_path

# Opcionales
export (int) var weight = 1 setget set_weight, get_weight
# Los RPGSlotsInventory tiene límite de stack
# pero RPGWeightInventory no tiene límite de stack
export (int) var stack_max = 10
var atributes = []

signal use_item

# Métodos Públicos y Setters/Getters
#

func create_item(_item_name, _desc, _amount = 1):
	item_name = _item_name
	desc = _desc
	amount = _amount

func use():
	emit_signal("use_item")

func set_item_name(_item_name):
	item_name = _item_name
	
func get_item_name():
	return item_name
	
func set_desc(_desc):
	desc = _desc
	
func get_desc():
	return desc
	
func set_buy_price(_buy_price):
	buy_price = _buy_price
	
func get_buy_price():
	return buy_price

func add_atribute(atribute_name, value):
	atributes.append([atribute_name, value])

func set_weight(_weight):
	weight = _weight
	
func get_weight():
	return weight

func set_sell_price(_sell_price):
	sell_price = _sell_price

func get_sell_price():
	return sell_price

func set_texture_path(_texture_path):
	texture_path = _texture_path

func get_texture_path():
	return texture_path

# Obtienes los atributos para ser imprimidos
func get_atributes_to_print():
	var to_print = ""
	
	for i in range(0, atributes.size()):
		to_print += str(atributes[i][0], ": ", atributes[i][1], "\n")

	return to_print

func set_extra_data(data):
	extra_data = data
	
func get_extra_data():
	return extra_data

# Métodos "Privados"
#