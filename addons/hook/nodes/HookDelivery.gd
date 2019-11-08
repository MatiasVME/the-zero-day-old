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

extends "Hook.gd"

class_name HookDelivery, "../icons/hook_delivery.png"

var deliveries := []
var timer

signal new_delivery(delivery)

func _ready():
	# Test
	create_delivery("Pizza", 10)
	connect("new_delivery", self, "_on_new_delivery")

	timer = Timer.new()
	timer.autostart = true
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")

func create_delivery(delivery_name, time_to_finalize, force_step = 0, can_be_finished = false, is_finished = false):
	var start_time_delivery = OS.get_unix_time()
	# delivery_name | time_to_finalize: en segundos | force_step | start_time_delivery | time_to_finalize: no debe cambiar
	deliveries.append([delivery_name, time_to_finalize, force_step, start_time_delivery, time_to_finalize, can_be_finished, is_finished])

func remove_delivery(delivery_name):
	for i in deliveries.size():
		if deliveries[i][0] == delivery_name:
			deliveries.remove(i)
			break
	
func force_step(delivery_name):
	var delivery = get_delivery(delivery_name)
	
	if delivery[6]:
		return
	
	delivery[1] -= delivery[2]

# Devuelve true si ya ha pasado el tiempo del delivery
func is_delivery_have_passed(delivery_name):
	# Obtener el delivery dependiendo del nombre
	var delivery = get_delivery(delivery_name)
	
	if delivery[6]:
		return
	
	if not delivery:
		print("No existe el delivery: ", delivery_name)
		return false
	
	var current_time = OS.get_unix_time()
	
	# last_time_delivery + time_tofinalize
	if current_time >= delivery[3] + delivery[1]:
		return true
	
	return false
	
# Devuelve el tiempo restante en segundos que queda para
# un nuevo delivery
func delivery_time(delivery_name):
	# Obtener el delivery dependiendo del nombre
	var delivery = get_delivery(delivery_name)
	
	if delivery[6]:
		return
	
	# time_to_finalize + last_time_delivery - current_time
	return clamp(delivery[1] + delivery[3] - OS.get_unix_time(), 0, 999999999999)

func str_delivery_time(delivery_name):
	# Obtener el delivery dependiendo del nombre
	var delivery = get_delivery(delivery_name)
	
	if delivery[6]:
		return
	
	var time_in_seconds = delivery_time(delivery_name)
	var date_time = OS.get_datetime_from_unix_time(time_in_seconds)
	
	if time_in_seconds < 0 or date_time.empty():
		return
	
	if  date_time["day"] - 1 != 0:
		return str("D: ", date_time["day"] - 1, " H: ", date_time["hour"], " M: ", date_time["minute"], " S: ", date_time["second"])
	elif date_time["day"] - 1 == 0 and date_time["hour"] > 0:
		return str("H: ", date_time["hour"], " M: ", date_time["minute"], " S: ", date_time["second"])
	elif date_time["day"] - 1 == 0 and date_time["hour"] == 0 and date_time["minute"] > 0:
		return str("M: ", date_time["minute"], " S: ", date_time["second"])
	else:
		return str("S: ", date_time["second"])

# Reinicia el tiempo de entrega del shop delivery a el tiempo
# actual
func reset_delivery_time(delivery_name):
	# Obtener el delivery dependiendo del nombre
	var delivery = get_delivery(delivery_name)
	
	if delivery[6]:
		return
	
	var current_time = OS.get_unix_time()
	delivery[3] = current_time

func get_delivery(delivery_name):
	for deli in deliveries:
		if deli.has(delivery_name):
			return deli
	
	print("No existe el delivery " + delivery_name)

func _on_Timer_timeout():
	for deli in deliveries:
		if not deli[6] and is_delivery_have_passed(deli[0]):
			reset_delivery_time(deli[0])
			
			if deli[5]:
				deli[6] = true
			
			emit_signal("new_delivery", deli)
	
func _on_new_delivery(delivery):
	print("Wiii pizza!!: ", delivery)