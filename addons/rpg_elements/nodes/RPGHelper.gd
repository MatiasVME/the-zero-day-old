# MIT License
#
# Copyright (c) 2018 - 2019 Matías Muñoz Espinoza
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
class_name RPGHelper, "../icons/RPGHelper.png"

func get_inst_character():
	return load("res://addons/rpg_elements/nodes/RPGCharacter.gd").new()
	
func get_inst_dialog():
	return load("res://addons/rpg_elements/nodes/RPGDialog.gd").new()

func get_inst_inventory():
	return load("res://addons/rpg_elements/nodes/RPGInventory.gd").new()
	
func get_inst_item():
	return load("res://addons/rpg_elements/nodes/RPGItem.gd").new()
	
func get_inst_stats():
	return load("res://addons/rpg_elements/nodes/RPGStats.gd").new()
	
func get_inst_weight_inventory():
	return load("res://addons/rpg_elements/nodes/RPGWeightInventory.gd").new()
	