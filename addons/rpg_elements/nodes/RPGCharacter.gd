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

class_name RPGCharacter, "../icons/RPGCharacter.png"

export (String) var character_name setget set_character_name, get_character_name

export (int) var level = 1 setget , get_level
export (int) var level_max = 30 setget set_level_max, get_level_max

# Vitalidad
export (int) var hp = 20 setget set_hp, get_hp
export (int) var max_hp = 20 setget set_max_hp, get_max_hp
# Mana
export (int) var energy = 20 setget set_energy, get_energy
export (int) var max_energy = 20 setget set_max_energy, get_max_energy
# 0% de defense
export (int) var defense_rate = 0 setget set_defense_rate, get_defense_rate
# TODO: Implementar escudo
# export (int) var shield
export (int) var attack = 1 setget set_attack, get_attack

var xp = 0
var xp_required = get_xp_required(level + 1)
var xp_total = 0
# XP que suelta al morir, útil para los enemigos
var xp_drop = 0

# Previene que muera más de una vez. Esto hace que el player
# no pueda ganar/perder vida/energía cuando esta muerto.
# Para revivirlo se debe utilizar revive().
# El character si puede ganar experiencia cuando esta muerto,
# la razón es que a veces se da experiencia al jugador cuando
# no se esta en la pantalla de juego. 
var is_dead = false

signal level_up(current_level)
signal add_xp(amount)
# Si muere, si drop_xp > 0, entonces dropea xp
signal drop_xp(amount)
# El amount es la cantidad que se añadió, no siempre es la
# cantidad enviada por medio de "add_hp(amount)"
signal add_hp(amount)
signal remove_hp(amount)
signal full_hp
signal dead
signal revive
signal add_energy(amount)
signal remove_energy(amount)
signal full_energy
signal no_energy
# TODO: Falta implementar los métodos add_defense, remove_defense
# signal add_defense # TODO
# signal remove_defense # TODO

func _ready():
	# Señales si esta en modo debug
	connect_debug_signals()

# Métodos Públicos
#

func connect_debug_signals():
	if debug:
		connect("level_up", self, "_on_level_up")
		connect("add_xp", self, "_on_add_xp")
		connect("add_hp", self, "_on_add_hp")
		connect("remove_hp", self, "_on_remove_hp")
		connect("full_hp", self, "_on_full_hp")
		connect("dead", self, "_on_dead")
		connect("revive", self, "_on_revive")
		connect("add_energy", self, "_on_add_energy")
		connect("remove_energy", self, "_on_remove_energy")
		connect("full_energy", self, "_on_full_energy")
		connect("no_energy", self, "_on_no_energy")

func add_xp(amount):
	if level >= level_max:
		.debug("Esta en el máximo nivel, la experiencia no fue añadida")
		return

	xp_total += amount
	xp += amount
	
	while xp >= xp_required:
		xp -= xp_required
		
		if level < level_max:
			level_up()
		else:
			break
	
	emit_signal("add_xp", amount)

func level_up():
	level += 1
	xp_required = get_xp_required(level + 1)
	
	emit_signal("level_up", level)

# Restaura una cantidad de hp (No supera la
# cantidad maxima)
func add_hp(_hp):
	if is_dead:
		.debug("add_hp(): El character esta muerto requiere ser revivido")
		return
		
	if hp + _hp < max_hp:
		hp += _hp
		emit_signal("add_hp", _hp)
	# Significa que se esta añadiendo más hp de lo que se podría
	else: 
		if hp == max_hp:
			.debug("No se puede añadir mas HP ya que esta lleno.")
			emit_signal("full_hp")
			return
		
		emit_signal("add_hp", _hp - (_hp - hp))
		hp = max_hp
		emit_signal("full_hp")

# No ignora la defensa
func damage(_hp):
	var damage = _hp - (_hp * defense_rate / 100)
	remove_hp(int(float(damage)))

# Ignora la defensa
func remove_hp(_hp):
	# Guarda el hp que se quita para luego enviarlo en 
	# la señal remove_hp
	var hp_deleted 
	
	if is_dead:
		.debug("remove_hp(): El character esta muerto requiere ser revivido")
		return
	
	if not _hp > 0:
		.debug("No se puede eliminar esa cantidad de HP")
		return
	
	if hp - _hp > 0:
		hp_deleted = _hp
		hp -= _hp
	else:
		hp_deleted = _hp - (_hp - hp)	
		hp = 0
		
		# Previene que no muera más de una vez
		if not is_dead:
			is_dead = true
			emit_signal("remove_hp", hp_deleted)
			emit_signal("dead")
			
			if xp_drop > 0: emit_signal("drop_xp", xp_drop)
			
			return
	
	emit_signal("remove_hp", hp_deleted)

func revive():
	if not is_dead:
		.debug("Ya esta vivo")
		return
	
	is_dead = false
	
	emit_signal("revive")
	restore_hp()

func add_energy(_energy):
	if is_dead:
		.debug("El character esta muerto requiere ser revivido")
		return

	if energy + _energy < max_energy:
		energy += _energy
		emit_signal("add_energy", _energy)
	else: # Significa que se esta añadiendo más hp de lo que se podría
		if energy == max_energy:
			.debug("No se puede añadir mas Energy ya que esta llena.")
			emit_signal("full_energy")
			return
		
		emit_signal("add_energy", _energy - (_energy - energy))
		energy = max_energy
		emit_signal("full_energy")
	
func remove_energy(_energy):
	if is_dead:
		.debug("remove_energy(): El character esta muerto requiere ser revivido")
		return
	
	if not _energy > 0:
		.debug("No se puede eliminar esa cantidad de Energy")
		return
	
	if energy - _energy > 0:
		emit_signal("remove_energy", _energy)
		energy -= _energy
	else:
		emit_signal("remove_hp", _energy - (_energy - energy))
		energy = 0

func restore_hp():
	if is_dead:
		.debug("El character esta muerto requiere ser revivido")
		return
	
	hp = max_hp
	emit_signal("full_hp")

# Setters/Getters
#

func get_xp():
	return xp

func get_xp_required(_level):
	return round(pow(_level, 1.8) + _level * 4)
	
func get_level():
	return level
	
func get_level_max():
	return level_max
	
func set_level_max(_level_max):
	level_max = _level_max

func set_character_name(_character_name):
	character_name = _character_name
	
func get_character_name():
	return character_name
	
func set_hp(_hp):
	hp = _hp
	
	if hp > max_hp:
		hp = max_hp
		emit_signal("full_hp")
	elif hp <= 0:
		hp = 0
		emit_signal("dead") # Es necesario?
	
func get_hp():
	return hp
	
func set_max_hp(_max_hp):
	if _max_hp > 0:
		max_hp = _max_hp
	else:
		.debug("_max_hp tiene que ser mayor que 0")
	
func get_max_hp():
	return max_hp

func set_energy(_energy):
	energy = _energy
	
	if energy > max_energy:
		energy = max_energy
		emit_signal("full_energy")
	elif energy <= 0:
		energy = 0
		emit_signal("no_energy")
	
func get_energy():
	return energy
	
func set_max_energy(_max_energy):
	max_energy = _max_energy
	
func get_max_energy():
	return max_energy
	
func set_defense_rate(_defense):
	defense_rate = _defense
	
func get_defense_rate():
	return defense_rate

func set_attack(_attack):
	attack = _attack
	
func get_attack():
	return attack

# Métodos "Privados"
#

# Señales
#

func _on_add_xp(amount):
	.debug("Añadir XP [", amount, "]")

func _on_level_up(current_level):
	.debug("Has subido de nivel!! [", current_level, "]")
	
func _on_get_xp():
	.debug("Obtener XP: ", xp)
	
func _on_remove_hp(amount):
	.debug("Eliminar HP [", amount, "]")
	
func _on_full_hp():
	.debug("HP esta lleno: ", hp)
	
func _on_dead():
	.debug("Has muerto: ", hp)
	
func _on_revive():
	.debug("Has revivido")

func _on_add_energy(amount):
	.debug("Añadir energía [", amount, "]")

func _on_remove_energy(amount):
	.debug("Eliminar energía [", amount, "]")
	
func _on_full_energy():
	.debug("Estas lleno de energía: ", energy)
	
func _on_no_energy():
	.debug("No queda energía")

func _on_add_hp(amount):
	.debug("HP Añadido [", amount, "]")