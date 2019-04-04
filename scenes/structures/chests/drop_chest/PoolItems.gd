extends Object
"""
PoolsItems es un script para definir conjuntos de items con
un peso de probabilidad para poder obtenerlos aleatoriamente
"""
var pool : Array = []
var total : float = 0

class ItemInPool:
	var phitem : PHItem
	var weight : int#Peso de probabilidad
	
	#Inicialización de un ItemInPool
	func _init(i : PHItem, w : int):
		phitem = i
		weight = w

#Agrega un item con un peso de probabilidad
func add_item_on_pool(item : PHItem, weight : int = 1) -> void:
	if weight < 1:
		print_debug("Weight is less than 1")
		return
	
	total += weight
	pool.append( ItemInPool.new(item, weight) )
	
#Remueve un item por posición en el conjunto (por defecto el último)
func remove_item_on_pool(pos : int = -1) -> void:
	if abs(pos) < pool.size():
		total -= pool[pos].weight
		pool.remove(pos)
	
#Retorna un PHItem al azar, si el parámetro erased es verdadero
# lo elimina del pool de objetos
func get_random_item(erase : bool = false) -> PHItem:
	if pool.empty():
		print_debug("PoolItem is empty")
		return null
	var random : = randf()
	var accumulator : float = 0.0
	var index : int = 0
	var item_in_pool = null
	
	while random >= accumulator:
		item_in_pool = pool[index]
		accumulator += item_in_pool.weight / total
		index += 1
	
	if erase:
		remove_item_on_pool(index -1)
	else:
		return Factory.ItemFactory.create_item_copy(item_in_pool.phitem)
	
	return item_in_pool.phitem
	
func is_empty() -> bool:
	return pool.empty()
	
#Para probar funcionalidad
func test() -> void:
	self.add_item_on_pool(Factory.ItemFactory.create_normal_ammo(8), 1 )
	self.add_item_on_pool(Factory.ItemFactory.create_normal_ammo(16), 3 )
	self.add_item_on_pool(Factory.ItemFactory.create_normal_ammo(32), 2 )
	self.add_item_on_pool(Factory.ItemFactory.create_plasma_ammo(8), 1 )
	self.add_item_on_pool(Factory.ItemFactory.create_plasma_ammo(16), 7 )
#	print_prob()
	
#Para imprimir las probabilidades acumuladas del conjunto
func print_prob() -> void:
	var accum : = 0.0
	for i in pool:
		accum += i.weight / total
		print(str(i.phitem.get_script().resource_path) + " : Probabilidad Acumulada = " + str(accum) )