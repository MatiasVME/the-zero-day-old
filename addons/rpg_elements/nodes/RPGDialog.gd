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
class_name RPGDialog, "../icons/RPGDialog.png"

# Estos son las propiedades que deben ser asignadas a la interfaz:
# transmitter_name : Es el nombre que emite el mensaje actual.
# avatar : texture de avatar, imagen actual. (Debe de ser un Sprite)
# text: texto actual. 
var transmitter_name setget , get_transmitter_name
var avatar setget , get_avatar
var text setget , get_text

# Posición del avatar
enum AvatarPos {LEFT, RIGHT}
var avatar_pos = AvatarPos.LEFT

var dialogue = []

var timer

# Se cambia el trasmitter_name
signal changed_transmitter_name # OK
# Se cambia el avatar
signal changed_avatar
# Pasa al siguiente texto
signal changed_text # OK
# Se actualiza el texto (por cada letra)
signal updated_text # OK
# Comienza el dialogo
signal start_dialog # OK
signal end_section # OK
# Termina el dialogo
signal end_dialog # OK
signal empty_dialog

var next_pressed = false

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(0.01)
	
	if self.debug:
		connect("changed_transmitter_name", self, "_on_changed_transmitter_name")
		connect("changed_avatar", self, "_on_changed_avatar")
		connect("changed_text", self, "_on_changed_text")
		connect("updated_text", self, "_on_updated_text")
		connect("start_dialog", self, "_on_start_dialog")
		connect("end_dialog", self, "_on_end_dialog")
		connect("end_section", self, "_on_end_section")
		connect("empty_dialog", self, "_on_empty_dialog")
		
	set_process(true)

func _process(delta):
	if next_pressed:
		next_pressed = false
		
		if is_finish:
			stop_dialog()
		else:
			timer.start()
		
		next_dialog()

# Métodos Públicos
#

func add_section(_transmitter_name, _text, _img = null, _avatar_pos = AvatarPos.LEFT):
	var section = new_section()
	
	section["TransmitterName"] = _transmitter_name
	section["Text"] = _text
	# Lo siguiente arregla un error al mostrar un texto, ya que no se muestra
	# la última letra:
	section["Text"] += " "
	
	section["Avatar"] = _img
	
	dialogue.append(section)
	
func get_dialogue():
	return dialogue
	
func start_dialog():
	if dialogue == null or current_text == null:
		debug("El dialogo es null: ", dialogue)
		return
	
	emit_signal("start_dialog")
	has_increased = true
	timer.start()

func next_pressed():
	next_pressed = true
	

# Setters/Getters
#
	
func get_transmitter_name():
	return transmitter_name
	
func get_avatar():
	return avatar

func get_text():
	return text

# Métodos "Privados"
#

var index_dialog = 0
var index_letter = 0
var current_text = ""
var text_progress = ""
var has_increased = false
var next_dialog = false
var is_finish = false

func new_section():
	var section = {
		TransmitterName = null,
		Text = null,
		Avatar = null
	}
	
	return section
	
func stop_dialog():
	dialogue = null

	index_dialog = 0
	index_letter = 0
	current_text = ""
	text_progress = ""
	has_increased = false
	next_dialog = false
	is_finish = false
	
	emit_signal("end_dialog")

# Es para ver si el index_dialog ha incrementado
func has_increased():
	if has_increased:
		has_increased = false
		return true
	else:
		return false

func next_dialog():
	if next_dialog:
		next_dialog = false
		emit_signal("changed_text")
		
		return true
	else:
		return false

# Events
#

func _on_Timer_timeout():
	debug("_on_Timer_timeout")
	
	if dialogue.empty():
		emit_signal("empty_dialog")
		return

	if next_dialog:
		text_progress = ""
		timer.stop()
		return
	
	if has_increased:
		current_text = dialogue[index_dialog]["Text"]
		
		if transmitter_name != dialogue[index_dialog]["TransmitterName"]:
			transmitter_name = dialogue[index_dialog]["TransmitterName"]
			emit_signal("changed_transmitter_name")
		
		if dialogue[index_dialog]["Avatar"] != null:
			if avatar != null and avatar.get_texture() != dialogue[index_dialog]["Avatar"].get_texture():
				avatar = dialogue[index_dialog]["Avatar"]
				emit_signal("changed_avatar")
			elif avatar == null:
				avatar = dialogue[index_dialog]["Avatar"]
				emit_signal("changed_avatar")
	
	if current_text.length() >= 1:
		text_progress += current_text[index_letter]
		index_letter += 1
	
	if index_letter == current_text.length():
		index_letter = 0
		index_dialog += 1
		has_increased = true
		next_dialog = true
		emit_signal("end_section")

	text = text_progress
	emit_signal("updated_text")
	debug(text)

	if dialogue != null and dialogue.size() == index_dialog and current_text.length() == text_progress.length():
		is_finish = true
		timer.stop()

func _on_changed_transmitter_name():
	debug("_on_changed_transmitter_name")
	
func _on_changed_avatar():
	debug("_on_changed_avatar")

func _on_changed_text():
	debug("_on_changed_text")
	
func _on_updated_text():
	debug("_on_updated_text")
	
func _on_start_dialog():
	debug("_on_start_dialog")
	
func _on_end_dialog():
	debug("_on_end_dialog")
	
func _on_end_section():
	debug("_on_end_section")
	
func _on_empty_dialog():
	debug("_on_empty_dialog")