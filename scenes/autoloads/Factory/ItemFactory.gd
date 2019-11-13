extends GGeneratorFactory

# Max points
const MAX_POINTS = 506

# Obsoleto
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

static func create_rand_distance_weapon(enemy_level := 1, enemy_type := Enums.EnemyType.NORMAL, player_luck := 1, ammo_type = null, adventure_current_max_level := 1):
	# Suma del progreso de adventure_current_max_level y la suerte
	var sum = (
		Utils.value2progress(enemy_level, 0, 100) +
		Utils.value2progress(enemy_type, 0, 4) + 
		Utils.value2progress(adventure_current_max_level, 0, 100) +
		Utils.value2progress(player_luck, 0, 100)
	) / 4.0
	
	var weapon = TZDDistanceWeapon.new()
	
	randomize()
	
	# Formula: valor_ref * valor_que_incrementa + pow(valor_que_incrementa, potencia_de_la_curva)
	weapon.buy_price = int(round(250 * sum + pow(sum, 1.65)))
	weapon.sell_price = int(round(weapon.buy_price / rand_range(3, 5)))
	
	if not weapon.ammo_type:
		weapon.ammo_type = int(round(rand_range(weapon.AmmoType.NORMAL, weapon.AmmoType.PLASMA)))
	
	print_debug(sum)
	
	if weapon.ammo_type == weapon.AmmoType.NORMAL:
		match 0:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/submachine/submachine_pistol.png"
				# Esta es una forma de invertir los valores cuando se requiere invertirlos
				weapon.time_to_next_action = Utils.progress2value(sum, 0.2, 0.07)
#				weapon.damage = int(round(Utils.progress2value(0.5 * sum + pow(sum, 1.65), 2, 2500)))
				weapon.damage = int(round(Utils.progress2value(sum / 300, 3, 10000)))
				weapon.time_to_reload = Utils.progress2value(sum, 1.0, 0.4)
				weapon.weapon_capacity = Utils.progress2value(sum / 0.75, 4, 16)
				weapon.item_name = "Submachine"
				
	elif weapon.ammo_type == weapon.AmmoType.PLASMA:
		var rand_num = int(round(rand_range(0, 1)))
		
		match rand_num:
			0: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nn1/PlasmaGunNN1.png"
				# Esta es una forma de invertir los valores cuando se requiere invertirlos
				weapon.time_to_next_action = Utils.progress2value(sum, 0.5, 0.025)
				weapon.damage = int(round(Utils.progress2value(sum - sum / 2)))
				weapon.time_to_reload = Utils.progress2value(sum, 1.0, 0.4)
				weapon.weapon_capacity = Utils.progress2value(sum / 0.75, 4, 8)
				
				weapon.item_name = "PlasmaGun"
			1: 
				weapon.texture_path = "res://scenes/items/weapons/distance_weapons/plasma_nx/PlasmaGunNX.png"
				weapon.time_to_next_action = Utils.progress2value(sum, 0.14, 0.07)
				weapon.damage = int(round(Utils.progress2value(sum - sum / 2.5)))
				weapon.time_to_reload = Utils.progress2value(sum, 1.0, 0.4)
				weapon.weapon_capacity = Utils.progress2value(sum / 0.75, 4, 16)
				weapon.item_name = "PlasmaGunNX"
	
	weapon.item_name = RandomNameGenerator.generate(3, 7, hash(weapon)) + " " + weapon.item_name
	
	# Redondeo
	weapon.damage = int(round(weapon.damage))
	weapon.weapon_capacity = int(round(weapon.weapon_capacity))
	
#	print_debug("sum: ", sum)
#	print_debug("buy_price: ", weapon.buy_price)
#	print_debug("sell_price: ", weapon.sell_price)
	
	return weapon

static func create_rand_item_pack_for_shop():
	var pack := []
	
	# Crear de 2 a 4 weapons
	for i in int(round(rand_range(2, 4))):
		var enemy_type = Enums.EnemyType.CHAMPION
		
		if rand_range(0,5) >= 4:
			enemy_type = Enums.EnemyType.EPIC
			
			if rand_range(0, 21) >= 20:
				enemy_type = Enums.EnemyType.UNIQUE
		
		pack.append(
			create_rand_distance_weapon(
				PlayerManager.get_current_player().level,
				enemy_type,
				DataManager.get_stats(DataManager.get_current_player())["Luck"],
				null,
				AdventureManager.current_maximum_level
			)
		)
	
	return pack

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

