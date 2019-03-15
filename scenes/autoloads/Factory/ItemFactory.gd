extends Node

# Max points
const MAX_POINTS = 10000.0
# Points por fragmentos
const POINTS = MAX_POINTS / 4.0
# Fragmento de enemy level
const EL_FRAGMENT = 1.1 # POINTS / 100.0
# Fragmento de enemy_type
const ET_FRAGMENT = 1.2 # POINTS / 3.0
# Fragmento de player_luck
const PL_FRAGMENT = 1.15 # POINTS / 100.0
# Fragmento de factor aleatorio
const FA_FRAGMENT = 1.05 # POINTS / 500.0

static func test():
	print("EL_FRAGMENT",EL_FRAGMENT)
	print("ET_FRAGMENT",ET_FRAGMENT)
	print("PL_FRAGMENT",PL_FRAGMENT)
	print("FA_FRAGMENT",FA_FRAGMENT)
	
	for i in range(1, 100):
		for j in range(1,4):
			print("level-", i ,"-enemylevel-",j ,": ", create_rand_distance_weapon(i, j, i))

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
	return points

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
	
	