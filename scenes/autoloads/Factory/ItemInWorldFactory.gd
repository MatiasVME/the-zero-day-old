extends Node

static func create_test_distance_weapon():
	var weapon_data = Factory.ItemFactory.create_test_distance_weapon()
	var weapon_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	weapon_in_world.data = weapon_data
	
	return weapon_in_world

static func create_test_ammo():
	var ammo = Factory.ItemFactory.create_test_ammo()
	var ammo_in_world = load("res://scenes/items/ItemInWorld.tscn").instance()
	
	ammo_in_world.data = ammo
	
	return ammo_in_world