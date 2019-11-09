extends GGeneratorFactory

# Max points
const MAX_POINTS = 506

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

static func create_rand_distance_weapon(enemy_level := 1, enemy_type := 1, player_luck := 1, ammo_type = null):
	var points = get_points(enemy_level, enemy_type, player_luck)
	var weapon = TZDDistanceWeapon.new()
	
#	print("points: ",points)
	
	weapon.buy_price = int(round(25 * points)) # TEMP
	weapon.sell_price = weapon.buy_price / 4
	
	if not ammo_type:
		weapon.ammo_type = int(round(rand_range(weapon.AmmoType.NORMAL, weapon.AmmoType.PLASMA)))
	
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
	
	if weapon.ammo_type == weapon.AmmoType.NORMAL:
		match 0:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/submachine/submachine_pistol.png"
				
				weapon.time_to_next_action = 0.15
				max_feature_time_to_next_action = 0.15
				min_feature_time_to_next_action = 0.001
				
				weapon.damage = 1.0
				max_feature_damage = 100.0
				min_feature_damage = 1.0
				
				weapon.time_to_reload = 1.0
				max_feature_time_to_reload = 1.0
				min_feature_time_to_reload = 0.05
				
				weapon.weapon_capacity = 4.0
				max_feature_weapon_capacity = 16.0
				min_feature_weapon_capacity = 4.0
				
				weapon.item_name = "Submachine"
				
	elif weapon.ammo_type == weapon.AmmoType.PLASMA:
		var rand_num = int(round(rand_range(0, 1)))
#		print("de 0 a 2: ", rand_num)
		match rand_num:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
				
				weapon.time_to_next_action = 0.5
				max_feature_time_to_next_action = 0.5
				min_feature_time_to_next_action = 0.025
				
				weapon.damage = 1.0
				max_feature_damage = 200.0
				min_feature_damage = 1.0
				
				weapon.time_to_reload = 1.0
				max_feature_time_to_reload = 1.0
				min_feature_time_to_reload = 0.4
				
				weapon.weapon_capacity = 3.0
				max_feature_weapon_capacity = 8.0
				min_feature_weapon_capacity = 3.0
				
				weapon.item_name = "PlasmaGunNN1"
			1: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nx/PlasmaGunNX.png"
				
				weapon.time_to_next_action = 0.15
				max_feature_time_to_next_action = 0.15
				min_feature_time_to_next_action = 0.001
				
				weapon.damage = 1.0
				max_feature_damage = 200.0
				min_feature_damage = 1.0
				
				weapon.time_to_reload = 1.0
				max_feature_time_to_reload = 1.0
				min_feature_time_to_reload = 0.05
				
				weapon.weapon_capacity = 6.0
				max_feature_weapon_capacity = 20.0
				min_feature_weapon_capacity = 6.0
				
				weapon.item_name = "PlasmaGunNX"

	# Añadir puntos
	if points > 0:
		var i = 0
		var rand_num
		
		while i < points:
			rand_num = int(round(randi() % 4) - 0.001)
			match rand_num:
				0:
					weapon.damage += max_feature_damage / (MAX_POINTS / 4)
					weapon.damage = clamp(weapon.damage, min_feature_damage, max_feature_damage)
					if weapon.damage == max_feature_damage: points += 1
				1:
					weapon.weapon_capacity += max_feature_weapon_capacity / (MAX_POINTS / 4)
					weapon.weapon_capacity = clamp(weapon.weapon_capacity, min_feature_weapon_capacity, max_feature_weapon_capacity)		
					if weapon.weapon_capacity == max_feature_weapon_capacity: points += 1
				2:
					weapon.time_to_next_action -= max_feature_time_to_next_action / (MAX_POINTS / 4)
					weapon.time_to_next_action = clamp(weapon.time_to_next_action, min_feature_time_to_next_action, max_feature_time_to_next_action)
					if weapon.time_to_next_action == max_feature_time_to_next_action: points += 1
				3:
					weapon.time_to_reload -= max_feature_time_to_reload / (MAX_POINTS / 4)
					weapon.time_to_reload = clamp(weapon.time_to_reload, min_feature_time_to_reload, max_feature_time_to_reload)
					if weapon.time_to_reload == max_feature_time_to_reload: points += 1
			
			i += 1

	weapon.item_name = RandomNameGenerator.generate(3, 7, hash(weapon)) + " " + weapon.item_name
	weapon.damage = int(round(weapon.damage))
	weapon.weapon_capacity = int(round(weapon.weapon_capacity))
	
#	print(weapon.item_name)
#	print("weapon.damage ",weapon.damage)
#	print("weapon.weapon_capacity ",weapon.weapon_capacity)
#	print("weapon.time_to_next_action ",weapon.time_to_next_action)
#	print("weapon.time_to_reload ",weapon.time_to_reload)
	
	return weapon

static func create_rand_distance_weapon_for_shop(adventure_current_max_level : int, luck : int):
	# Suma del progreso de adventure_current_max_level y la suerte
	var sum = (
		Utils.progress2value(adventure_current_max_level, 1, 100) + 
		Utils.progress2value(luck, 1, 100)
	)
	
	var weapon = TZDDistanceWeapon.new()
	
	# Formula: valor_ref * valor_que_incrementa + pow(valor_que_incrementa, potencia_de_la_curva)
	weapon.buy_price = int(round(350 * sum + pow(sum, 1.65)))
	weapon.sell_price = weapon.buy_price / 4
	
	weapon.ammo_type = int(round(rand_range(weapon.AmmoType.NORMAL, weapon.AmmoType.PLASMA)))
	
	if weapon.ammo_type == weapon.AmmoType.NORMAL:
		match 0:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/submachine/submachine_pistol.png"
				weapon.time_to_next_action = Utils.progress2value(sum / 1000, 0.001, 0.14)
				weapon.damage = Utils.progress2value(sum, 1, 100)
				weapon.time_to_reload = Utils.progress2value(sum / 100, 1.0, 0.05)
				weapon.weapon_capacity = Utils.progress2value(sum / 0.75, 4, 16)
				weapon.item_name = "Submachine"
				
	elif weapon.ammo_type == weapon.AmmoType.PLASMA:
		var rand_num = int(round(rand_range(0, 1)))
		
		match rand_num:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
				weapon.time_to_next_action = Utils.progress2value(sum / 6, 0.025, 0.5)
				weapon.damage = Utils.progress2value(sum, 2, 200)
				weapon.time_to_reload = Utils.progress2value(sum / 7.5, 0.04, 1.0)
				weapon.weapon_capacity = Utils.progress2value(sum, 3, 8)
				weapon.item_name = "PlasmaGun"
			1: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nx/PlasmaGunNX.png"
				weapon.time_to_next_action = Utils.progress2value(sum / 2000, 0.001, 0.15)
				weapon.damage = Utils.progress2value(sum / 0.9, 2, 200)
				weapon.time_to_reload = Utils.progress2value(sum / 6, 0.05, 1.0)
				weapon.weapon_capacity = Utils.progress2value(sum, 6.0, 20.0)
				weapon.item_name = "PlasmaGunNX"
	
	weapon.item_name = RandomNameGenerator.generate(3, 7, hash(weapon)) + " " + weapon.item_name
	
#	print_debug("sum: ", sum)
#	print_debug("buy_price: ", weapon.buy_price)
#	print_debug("sell_price: ", weapon.sell_price)
	
	return weapon

static func create_normal_ammo(ammo_amount := 32):
	var ammo = TZDAmmo.new()
	
	ammo.item_name = "Normal Ammo"
	ammo.ammo_amount = ammo_amount
	ammo.ammo_type = ammo.AmmoType.NORMAL
	ammo.buy_price = ammo_amount * 10
	ammo.sell_price = ammo.buy_price / 4
	ammo.texture_path = "res://scenes/items/ammo/normal/normal_bullet_ammo.png"
	
	return ammo

static func create_plasma_ammo(ammo_amount := 16):
	var ammo = TZDAmmo.new()
	
	ammo.item_name = "Plasma Ammo"
	ammo.ammo_amount = ammo_amount
	ammo.ammo_type = ammo.AmmoType.PLASMA
	ammo.buy_price = ammo_amount * 20
	ammo.sell_price = ammo.buy_price / 4
	ammo.texture_path = "res://scenes/items/ammo/plasma/plasma_bullet_ammo.png"
	
	return ammo

static func create_rand_melee_weapon(enemy_level := 1, enemy_type := 1, player_luck := 1, weapon_type = null):
	var points = get_points(enemy_level, enemy_type, player_luck)
	var weapon = TZDMeleeWeapon.new()
	
	weapon.buy_price = int(round(20 * points)) # TEMP
	weapon.sell_price = weapon.buy_price / 4

#	TEMP	
#	if not weapon_type:
#		weapon.weapon_type = int(round(rand_range(weapon.WeaponType.IRON_SWORD, weapon.WeaponType.RUBY_SWORD)))
	
	if points > MAX_POINTS / 4 * 3:
		weapon.texture_path = "res://scenes/items/weapons/melee_weapons/swords/ruby/RSword" + str(int(round(rand_range(1, 5)))) + ".png"
		weapon.item_name = "Ruby "
	elif points > MAX_POINTS / 4 * 2:
		weapon.texture_path = "res://scenes/items/weapons/melee_weapons/swords/diamond/DSword" + str(int(round(rand_range(1, 4)))) + ".png"
		weapon.item_name = "Diamond "
	elif points > MAX_POINTS / 4 * 1:
		weapon.texture_path = "res://scenes/items/weapons/melee_weapons/swords/emerald/ESword" + str(int(round(rand_range(1, 2)))) + ".png"
		weapon.item_name = "Emerald "
	else:
		weapon.texture_path = "res://scenes/items/weapons/melee_weapons/swords/iron/ISword" + str(int(round(rand_range(1, 4)))) + ".png"
		weapon.item_name = "Iron "
		
	weapon.time_to_next_action = 0.8
	weapon.time_to_next_action -= 0.05 * (points / 3)
	weapon.damage = 1.3 * (points / 3)
	weapon.distance = 1.0 * (points / 3)
	
	weapon.item_name = weapon.item_name + RandomNameGenerator.generate(3, 5, hash(weapon)) + " Sword"
	
	return weapon
	
static func create_structure_box(StructureBoxType):
	pass

