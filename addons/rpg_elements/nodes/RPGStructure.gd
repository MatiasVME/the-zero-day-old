# MIT License
#
# Copyright (c) 2019 Markus Ellisca
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
class_name RPGStructure # Aun no hay imagen

export (String) var structure_name setget set_structure_name, get_structure_name

# El Player propietario de la estructura, por el momento solo es un string pero se cambiará
export (String) var player_owner setget set_player_owner, get_player_owner

# Vitalidad de la estructura, talves deberia cambiarse de HP a algo diferente
export (int) var hp = 20 setget set_hp, get_hp
export (int) var max_hp = 20 setget set_max_hp, get_max_hp

# 0% de defense, talves deberia cambiarse por Armor ?
export (int) var defense_rate = 0 setget set_defense_rate, get_defense_rate

#export (int) var attack = 1 setget set_attack, get_attack

# XP que suelta al morir, deberia soltar xp?
var xp_drop = 0

# Previene que muera sea destruido mas de una vez
var is_destroyed = false

# Si muere, si drop_xp > 0, entonces dropea xp
signal drop_xp(amount)

# El amount es la cantidad que se añadió, no siempre es la
# cantidad enviada por medio de "add_hp(amount)"
signal add_hp(amount)
signal remove_hp(amount)
signal full_hp
signal destroy
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
		connect("add_hp", self, "_on_add_hp")
		connect("remove_hp", self, "_on_remove_hp")
		connect("full_hp", self, "_on_full_hp")
		connect("destroy", self, "_on_destroy")


func add_hp(_hp):
	if is_destroyed:
		.debug("add_hp(): La estructura esta destruida no puede añadirse hp")
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
	
	if is_destroyed:
		.debug("remove_hp(): La estructura esta destruida no puede quitarse hp")
		return
	
	if not _hp > 0:
		.debug("No se puede eliminar esa cantidad de HP")
		return
	
	if hp - _hp > 0:
		hp_deleted = _hp
		hp -= _hp
	else:
		hp_deleted = hp
		hp = 0
		
		# Previene que no muera más de una vez
		if not is_destroyed:
			is_destroyed = true
			emit_signal("remove_hp", hp_deleted)
			emit_signal("destroy")
			
			if xp_drop > 0: emit_signal("drop_xp", xp_drop)
			
			return
	
	emit_signal("remove_hp", hp_deleted)

func restore_hp():
	if is_destroyed:
		.debug("La estructura esta destruida no puede añadirse hp")
		return
	
	hp = max_hp
	emit_signal("full_hp")

# Setters/Getters
#

func set_structure_name(_structure_name):
	structure_name = _structure_name
	
func get_structure_name():
	return structure_name

func set_player_owner(_player_owner):
	player_owner = _player_owner
	
func get_player_owner():
	return player_owner

func set_hp(_hp):
	hp = _hp
	
	if hp > max_hp:
		hp = max_hp
		emit_signal("full_hp")
	elif hp <= 0:
		hp = 0
		emit_signal("destroy") # Es necesario?
	
func get_hp():
	return hp
	
func set_max_hp(_max_hp):
	if _max_hp > 0:
		max_hp = _max_hp
	else:
		.debug("_max_hp tiene que ser mayor que 0")
	
func get_max_hp():
	return max_hp

func set_defense_rate(_defense):
	defense_rate = _defense
	
func get_defense_rate():
	return defense_rate

#func set_attack(_attack):
#	attack = _attack
	
#func get_attack():
#	return attack

# Métodos "Privados"
#

# Señales
#

func _on_remove_hp(amount):
	.debug("Eliminar HP [", amount, "]")
	
func _on_full_hp():
	.debug("HP esta lleno: ", hp)
	
func _on_destroy():
	.debug("La estructura ha sido destruida")

func _on_add_hp(amount):
	.debug("HP Añadido [", amount, "]")


