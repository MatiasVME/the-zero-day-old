extends Node

static func create_test_distance_weapon():
	var weapon = PHDistanceWeapon.new()
	
	weapon.item_name = "Test Weapon"
	weapon.damage = 3
	weapon.buy_price = 200
	weapon.sell_price = weapon.buy_price / 4
	weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
	
	return weapon
	
static func create_test_ammo():
	var ammo = PHAmmo.new()
	
	ammo.item_name = "Test Ammo"
	ammo.ammo_amount = 16
	ammo.ammo_type = ammo.AmmoType.NORMAL
	ammo.buy_price = ammo.ammo_amount * 10
	ammo.sell_price = ammo.buy_price / 4
	ammo.texture_path = "res://scenes/items/ammo/normal_ammo/Ammo.png"
	
	return ammo