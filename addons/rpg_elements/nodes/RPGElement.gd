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

extends Node

class_name RPGElement

export (bool) var debug = false

func debug(message, something1 = "", something2 = ""):
	if debug:
		print("[RPGElements] ", message, " ", something1, " ", something2)

# Función para convertir la extención .gdc a .gd
static func gdc2gd(dict):
	if typeof(dict) == TYPE_DICTIONARY and dict.has("@path"):
		dict["@path"] = dict["@path"].replace('.gdc', '.gd')
		return dict
	else:
		print("gdc2gd(): No es un diccionario o no se encuentra el path")
		return dict

#func _notification(what):
#	if debug and what == NOTIFICATION_PREDELETE:
#		print("se elimina automaticamente el objeto ", self)