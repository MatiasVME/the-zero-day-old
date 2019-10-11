# TODO: Usar preload en vez de load

extends Node
	
static func create_rand_distance_weapon(enemy_level := 1, enemy_type := 1, player_luck := 1):
	var weapon_data = Factory.ItemFactory.create_rand_distance_weapon(enemy_level, enemy_type, player_luck)
	var weapon_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	weapon_in_world.data = weapon_data
	
	return weapon_in_world

static func create_rand_melee_weapon(enemy_level := 1, enemy_type := 1, player_luck := 1):
	var weapon_data = Factory.ItemFactory.create_rand_melee_weapon(enemy_level, enemy_type, player_luck)
	var weapon_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	weapon_in_world.data = weapon_data
	
	return weapon_in_world

static func create_normal_ammo(amount := 64):
	var ammo = Factory.ItemFactory.create_normal_ammo(amount)
	var ammo_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	ammo_in_world.data = ammo
	
	return ammo_in_world
	
static func create_plasma_ammo(amount := 48):
	var ammo = Factory.ItemFactory.create_plasma_ammo(amount)
	var ammo_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	ammo_in_world.data = ammo
	
	return ammo_in_world

# Encapsula un Item en un ItemInWorld
static func create_from_item(item):
	var item_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	item_in_world.data = item
	
	return item_in_world