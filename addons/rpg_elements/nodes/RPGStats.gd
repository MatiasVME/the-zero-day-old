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
class_name RPGStats, "../icons/RPGStats.png"

# Almacena las stats en si y los puntos relacionados con la stat, por
# ejemplo: [["Fuerza", 3, 50], ["Inteligencia", 2, 25]].
var stats = [] # No se debe editar directamente
# Puntos que se acumulan para añadir a las stats
var points = 0 setget , get_points # No se debe editar directamente

# Métodos Públicos
#

# Añadir una stat con una determinada cantidad de puntos
func add_stat(stat_name, points, max_points):
	stats.append([stat_name, points, max_points])

# Añadir puntos para acumular en points, estos puntos pueden ser usados
# para ser añadidos con el método add_points_to_stat()
func add_points(_points):
	if _points > 0:
		points += _points
	else:
		.debug("_points debe ser mayor que 0")

# Remueve una cantidad de puntos que son acumulados en points.
func remove_points(_points):
	if _points > 0:
		points -= _points
	else:
		.debug("_points debe ser mayor que 0")
		
# Toma puntos de points y los añade a x stat, devuelve true o false
# si la añade o no.
func add_points_to_stat(amount, stat_name):
	if can_add_points_to_stat(stat_name, amount):
		points -= amount
		get_stat(stat_name)[1] += amount
	else:
		.debug("No se pudieron añadir puntos a la stat")

# Pregunta si se puede añadir puntos a x stat. Dependiendo de los
# points y el máximo de puntos que puede tener una stat.
func can_add_points_to_stat(stat_name, amount = 1):
	if amount <= points and amount + get_stat_value(stat_name) <= get_stat_max_value(stat_name):
		return true
	else:
		return false

# Quita puntos a una stat y los guarda en points
func remove_points_to_stat(cant, stat_name):
	var stat = get_stat(stat_name)
	
	if cant > 0 and cant <= stat[1]:
		stat[1] -= cant
		points += cant
	else:
		.debug("No se puede remover esa cantidad de puntos")

# Borra todas las stats
func clear_stats():
	stats.clear()
	stats = []

# Setters/Getters
#

func get_points():
	return points

# Retorna el valor de la stat
func get_stat_value(stat_name):
	return get_stat(stat_name)[1]

# Retorna el valor maximo de la stat
func get_stat_max_value(stat_name):
	return get_stat(stat_name)[2]
	
# Retorna el arreglo de la stat
func get_stat(stat_name):
	for i in range(0, stats.size()):
		if stats[i][0] == stat_name:
			return stats[i] 
	
	.debug("No se ecuentra stat_name: ", stat_name)

func get_stats():
	return stats
	
func get_stat_names():
	var stats_names := []
	
	for stat in stats:
		stats_names.append(stat[0])
	
	return stats_names

func get_stat_assigned_points(stat_name):
	var stat_assigned_points : int
	
	for stat in stats:
		if stat[0] == stat_name:
			return stat[1]
	