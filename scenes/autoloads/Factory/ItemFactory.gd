extends Node

static func create_test_distance_weapon():
	var weapon = PHDistanceWeapon.new()
	
	weapon.item_name = "Test Weapon"
	weapon.item_desc = ""
	weapon.damage = 3
	weapon.buy_price = 200
	weapon.sell_price = weapon.buy_price / 4
	weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
	
	return weapon