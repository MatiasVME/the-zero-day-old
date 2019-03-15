extends Node

# Max points
const MAX_POINTS = 506
# Fragmento de enemy level
const EL_FRAGMENT = 1.1
# Fragmento de enemy_type
const ET_FRAGMENT = 1.2
# Fragmento de player_luck
const PL_FRAGMENT = 1.15
# Fragmento de factor aleatorio
const FA_FRAGMENT = 1.05

static func test():
	print("EL_FRAGMENT: ",EL_FRAGMENT)
	print("ET_FRAGMENT: ",ET_FRAGMENT)
	print("PL_FRAGMENT: ",PL_FRAGMENT)
	print("FA_FRAGMENT: ",FA_FRAGMENT)
	
#	for i in range(1, 100):
#		for j in range(1,4):
#			print("level-", i ,"-enemylevel-",j ,": ", create_rand_distance_weapon(i, j, i))
	
	var mayor = 0
	var menor = 999
	var current = 0

#	for i in 1000000:
#		current = create_rand_distance_weapon(100, 3, 100)
#		if current > mayor:
#			mayor = current
#			print("mayor: ", mayor)
#		elif current < menor:
#			menor = current
#			print("menor: ", menor)
			
	# Segun el test anterior el maximo es 505.7
	# se podria aproximar a 506

static func get_points(enemy_level, enemy_type, player_luck):
	var points = 0.0
	randomize()
	
	points += EL_FRAGMENT * (randi() % enemy_level) + enemy_level
#	print(points)
	points += ET_FRAGMENT * (randi() % enemy_type * 25) + enemy_type
#	print(points)
	points += PL_FRAGMENT * (randi() % player_luck) + player_luck
#	print(points)
	points += FA_FRAGMENT * (randi() % 20)
#	print(points)
	
	return points

static func create_rand_distance_weapon(enemy_level := 1, enemy_type := 1, player_luck := 1):
	var points = get_points(enemy_level, enemy_type, player_luck)
	var weapon = PHDistanceWeapon.new()
	
	weapon.buy_price = 25 * points # temp
	weapon.sell_price = weapon.buy_price / 4
	
	weapon.weapon_type = int(round(rand_range(0, 1)))
	
	# Caracteristicas de las armas que dependen de los puntos
	var feature_damage = 0
	var max_feature_damage = 0
	var min_feature_damage = 0
	
	var feature_time_to_next_action = 0
	var max_feature_time_to_next_action = 0
	var min_feature_time_to_next_action = 0
	
	var feature_time_to_reload = 0
	var max_feature_time_to_reload = 0
	var min_feature_time_to_reload = 0
	
	var feature_weapon_capacity = 0
	var max_feature_weapon_capacity = 0
	var min_feature_weapon_capacity = 0
	
	if weapon.weapon_type == 0:
		match 0:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/submachine/submachine_pistol.png"
				
				weapon.time_to_next_action = 0.25
				max_feature_time_to_next_action = 0.001
				min_feature_time_to_next_action = 0.015
				
				weapon.damage = 1.0
				max_feature_damage = 100.0
				min_feature_damage = 1.0
				
				weapon.time_to_reload = 1.0
				max_feature_time_to_reload = 1.0
				min_feature_time_to_reload = 0.1
				
				weapon.weapon_capacity = 4.0
				max_feature_weapon_capacity = 32.0
				min_feature_weapon_capacity = 4.0
				
				weapon.item_name = "Submachine"
				
	elif weapon.weapon_type == 1:
		match int(round(randi() % 1)):
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
				
				weapon.item_name = "PlasmaGunNN1"
			1: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nx/PlasmaGunNX.png"
				
				weapon.item_name = "PlasmaGunNX"

	# Añadir puntos
	if points > 0:
		for i in points:
			match int(round(randi() % 3)):
				0:
					weapon.damage += (max_feature_damage - min_feature_damage) / (MAX_POINTS / 4)
				1:
					weapon.weapon_capacity += max_feature_weapon_capacity / (MAX_POINTS / 4)
				2:
					weapon.time_to_next_action -= (min_feature_time_to_next_action - max_feature_time_to_next_action) / (MAX_POINTS / 4)
				3:
					weapon.time_to_reload -= (max_feature_time_to_reload - min_feature_time_to_reload) / (MAX_POINTS / 4)
				

	weapon.item_name = RandomNameGenerator.generate(3, 7, hash(weapon)) + " " + weapon.item_name
	
	print(weapon.item_name)
	
	weapon.damage = int(round(weapon.damage))
	weapon.weapon_capacity = int(round(weapon.weapon_capacity))
	# Nope
#	weapon.time_to_next_action = int(round(weapon.time_to_next_action))
#	weapon.time_to_reload = int(round(weapon.time_to_reload))
	
	return weapon

static func create_test_distance_weapon():
	var weapon = PHDistanceWeapon.new()
	
	weapon.item_name = "Test Weapon"
	weapon.damage = 3
	weapon.buy_price = 200
	weapon.sell_price = weapon.buy_price / 4
	weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
	weapon.time_to_next_action = 0.2
	
	return weapon
	
static func create_normal_ammo():
	var ammo = PHAmmo.new()
	
	ammo.item_name = "Test Ammo"
	ammo.ammo_amount = 16
	ammo.ammo_type = ammo.AmmoType.NORMAL
	ammo.buy_price = ammo.ammo_amount * 10
	ammo.sell_price = ammo.buy_price / 4
	ammo.texture_path = "res://scenes/items/ammo/normal/normal_bullet_ammo.png"
	
	return ammo
	
	