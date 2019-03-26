extends GChest
"""
NormalChest es un cofre sin llave que puede contener items normales
"""
var pool_items : Array = []

func _ready():
	add_random_items()#Para pruebas

#Funcion para definir los tipos de items que puede contener
#si se utiliza el llenado aleatorio 	
func create_pool_items() -> void:
	pool_items.append("Normal Ammo 8")
	pool_items.append("Normal Ammo 8")
	pool_items.append("Normal Ammo 16")
	pool_items.append("Normal Ammo 32")
	pool_items.append("Plasma Ammo 8")
	pool_items.append("Plasma Ammo 16")
	
func add_random_items() -> void:
	create_pool_items()
	var random : = RandomNumberGenerator.new()
	random.randomize()
	while not is_full():
		var item : PHItem
		match pool_items[random.randi() % pool_items.size()]:
			"Normal Ammo 8":
				item = Factory.ItemFactory.create_normal_ammo(8)
			"Normal Ammo 16":
				item = Factory.ItemFactory.create_normal_ammo(16)
			"Normal Ammo 32":
				item = Factory.ItemFactory.create_normal_ammo(32)
			"Plasma Ammo 8":
				item = Factory.ItemFactory.create_plasma_ammo(8)
			"Plasma Ammo 16":
				item = Factory.ItemFactory.create_plasma_ammo(16)
		add_item(item)
	

#Función sobreescrita de GChest que define la máquina de estados
func _change_state(new_state : int) -> bool:
	match new_state:
		States.CLOSED:
			if state == States.OPENED:
				state = new_state
		States.OPENED:
			if state == States.CLOSED:
				state = new_state
		_:
			return false
	return true