extends GGeneratorFactory

"""
Genera packs de items para luego agregarlos a
tesoros drops de jefes entre otros.
"""

const MAX_POINTS = 326
const MIN_POINTS = 3

enum PackCategory {
	POOR = 1,
	NORMAL,
	RARE,
	EPIC
}

static func get_points(pack_category = PackCategory.NORMAL, player_luck := 1):
	var points = 0.0
	randomize()

	points += PC_FRAGMENT * (randi() % pack_category * 27) + pack_category
	points += PL_FRAGMENT * (randi() % player_luck) + player_luck
	points += FA_FRAGMENT * (randi() % 20)

	return points

# Devuelve un pack de items dependiendo de la categoria y
# la suerte del jugador, se le puede indicar (opcionalmente la cantidad de items)
static func create_pack(pack_category = PackCategory.NORMAL, player_luck := 1, item_amount = null):
	var points = float(get_points(pack_category, player_luck))
	var points_for_item := []
	
	# Dar puntos por item
	if not item_amount:
		for i in range(1, 41):
			item_amount += 1
			
			if points / i < 10:
				break
	
	pass # TODO: Pensar...

static func create_pack_for_shop():
	var item_pack := []
	
	# Crear 2 a 4 armas
	#
	
	var total_weapons = int(round(rand_range(2, 4)))
	
	for i in total_weapons:
		var item = Factory.ItemFactory.create_rand_distance_weapon_for_shop(AdventureManager.current_maximum_level, DataManager.get_stats(DataManager.get_current_player())["Luck"])
	
	# Crear municiones random
	#
	
	pass

static func test():
	print("PC_FRAGMENT: ",PC_FRAGMENT)
	print("PL_FRAGMENT: ",PL_FRAGMENT)
	print("FA_FRAGMENT: ",FA_FRAGMENT)
	
	var mayor = 0
	var menor = 999
	var current = 0

	for i in 1000000:
		# Min points
#		current = get_points()
		# Max points
		current = get_points(4, 100)
		if current > mayor:
			mayor = current
		elif current < menor:
			menor = current
	
	print("mayor: ", mayor)
	print("menor: ", menor)