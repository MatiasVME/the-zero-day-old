extends Node

# En la alpha v0.2.0 existira solo el usuario User por default
var current_user := "User"

var global_config # Es una referencia al diccionario de $GlobalConfig
var user_config # Es una referencia al diccionario de $DataUserConfig

# Instancias, para ser utilizadas. Instancias de RPGElements.
var players = []
var inventories = []
var stats = []

# El player el cual tiene el foco o es el actual
var current_player : int = 0 setget set_current_player, get_current_player

# Si este numero cambia la data se borra, normalmente el numero
# debe ir incrementando
var delete_data = 3

func _ready():
	configure_persistence_node()
	create_or_load_data_if_not_exist()
	
#	create_player() # Solo para Test

func configure_persistence_node():
	if Main.DEBUG:
		$DataGlobalConfig.mode = $DataGlobalConfig.Mode.TEXT
		$DataUserConfig.mode = $DataUserConfig.Mode.TEXT
		$DataPlayers.mode = $DataPlayers.Mode.TEXT
		$DataInventories.mode = $DataInventories.Mode.TEXT
		$DataStats.mode = $DataInventories.Mode.TEXT
	else:
		$DataGlobalConfig.mode = $DataGlobalConfig.Mode.ENCRYPTED
		$DataUserConfig.mode = $DataUserConfig.Mode.ENCRYPTED
		$DataPlayers.mode = $DataPlayers.Mode.ENCRYPTED
		$DataInventories.mode = $DataInventories.Mode.ENCRYPTED
		$DataStats.mode = $DataInventories.Mode.ENCRYPTED
	
	$DataGlobalConfig.folder_name = "Global"
	
	$DataUserConfig.folder_name = current_user
	$DataPlayers.folder_name = current_user
	$DataInventories.folder_name = current_user
	$DataStats.folder_name = current_user

func create_or_load_data_if_not_exist():
	global_config = $DataGlobalConfig.get_data()
	
	if global_config.empty():
		# Crea la data
		#

		create_global_config()
		create_players()
		create_user_config()
		create_inventories()
		create_stats()
	elif global_config["DeleteData"] != delete_data:
		remove_all_data()
		get_tree().quit()
	else:
		# Carga la data
		#
		
		# GlobalConfig ya se cargo anteriormente.
		
		load_players()
		load_user_config()
		load_inventories()
		load_stats()

func save_all_data():
	save_players()
	save_user_config()
	save_inventories()
	save_stats()

func create_global_config():
	global_config["DeleteData"] = delete_data
	$DataGlobalConfig.save_data()
	
func create_players():
	var temp_data
	temp_data = $DataPlayers.get_data("Players")
	
	players.append(PHCharacter.new())
	temp_data[players.size() - 1] = inst2dict(players[players.size() - 1])
	
	# TEMP: Crea otro player
	players.append(PHCharacter.new())
	temp_data[players.size() - 1] = inst2dict(players[players.size() - 1])
	
	$DataPlayers.save_data("Players")
	
func save_players():
	var temp_data = $DataPlayers.get_data("Players")
	temp_data.clear()
	
	for i in players.size():
		temp_data[i] = RPGElement.gdc2gd(inst2dict(players[i]))
	
	# print("temp_data: ",temp_data)
	
	$DataPlayers.save_data("Players")
	
func load_players():
	var temp_data = $DataPlayers.get_data("Players")
	players = []

	for player in temp_data.values():
		players.append(dict2inst(player))
		
#	print("cargado los players: ", players)

func create_user_config():
	user_config = $DataUserConfig.get_data("UserConfig")

#	shop_inventory = $HMRPGHelper.get_inst_weight_inventory()
#	ItemGenerator.create_item_pack_for_shop(shop_inventory)
	
#	Main.init_basic_user_config()
#	AchievementsManager.create_all_achievements()
	
	save_user_config()

func load_user_config():
	user_config = $DataUserConfig.get_data("UserConfig")
	
func save_user_config():
#	user_config["Gold"] = Main.current_gold
#	user_config["Emeralds"] = Main.current_emeralds
#	user_config["CurrentLevel"] = Main.current_level

	$DataUserConfig.save_data("UserConfig")

func create_inventories():
	var w_inv = RPGWeightInventory.new()
	w_inv.max_weight = 25 # Cantidad temporal
	
	inventories.append(w_inv)
	
	save_inventories()
	
func save_inventories():
	var temp_data = $DataInventories.get_data("Inventories")
	temp_data.clear()

	for i in inventories.size():
		temp_data[i] = inventories[i].inv2dict()

	$DataInventories.save_data("Inventories")
	
func load_inventories():
	var temp_data = $DataInventories.get_data("Inventories")
	var temp_inv = RPGWeightInventory.new()
	inventories = []
	
	for inventory in temp_data.values():
		inventories.append(temp_inv.dict2inv(inventory))
		
#	print("inventories", inst2dict(inst2dict(inventories[0])["inv"][0]))
	
func create_stats():
	var temp_stats = $DataStats.get_data("Stats")

	var first_stats = RPGStats.new()
	first_stats.add_stat("Strength", 0, 100)
	first_stats.add_stat("Luck", 0, 100)
	first_stats.add_stat("Vitality", 0, 100)
	
	# TEMP
	first_stats.add_points(5)
	
	stats.append(first_stats)
	
	temp_stats[stats.size() - 1] = inst2dict(stats[stats.size() - 1])
	
	$DataStats.save_data("Stats")
	
func load_stats():
	var temp_data = $DataStats.get_data("Stats")
	stats = []

	for stat in temp_data.values():
		stats.append(dict2inst(stat))

func save_stats():
	var temp_data = $DataStats.get_data("Stats")
	temp_data.clear()
	
	for i in stats.size():
		temp_data[i] = RPGElement.gdc2gd(inst2dict(stats[i]))

	$DataStats.save_data("Stats")
	
func remove_all_data():
	$DataGlobalConfig.remove_all_data()
	$DataPlayers.remove_all_data()
	$DataUserConfig.remove_all_data()
	$DataInventories.remove_all_data()
	$DataStats.remove_all_data()

func set_current_player(player_num : int) -> void:
	current_player = player_num

func get_current_player() -> int:
	return current_player

func get_current_player_instance():
	return players[current_player]
	
func get_next_player():
	# players es el conjunto de players, no
	# necesariamente instanciados en el juego
	if players.size() > 0:
		# Si no ha llegado al limite
		return (current_player + 1) % players.size()
	
func set_next_player():
	current_player = get_next_player()
	
func get_current_inv():
	return inventories[current_player]

func get_current_stats():
	return stats[current_player]

# Funcion que crea un nuevo player con sus datos asociados,
# crea la data del player, la data del inventario y la data
# del jugador. Y lo añade a la lista de players.
func create_player():
	players.append(PHCharacter.new())
	inventories.append(RPGInventory.new()) # Por el momento
	stats.append(RPGStats.new()) # Por el momento

func get_stats(player_num : int):
	return stats[player_num]