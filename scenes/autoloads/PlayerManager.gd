"""
PlayerManager.gd

Gestiona las instancias de los players (GPlayer).
"""

extends Node

# Son los GPlayers que el jugador puede llegar a controlar
var players = []
var current_player = get_current_player() setget , get_current_player

enum PlayerType {
	DORBOT,
	MATBOT,
	PIXBOT,
	SERBOT
}
var player_type = PlayerType.MATBOT # Cambiar a DORBOT mas adelante

# Este es el player connectado, se usa esta variable
# para luego desconectarlo
var current_player_connected

signal player_changed(new_player)
signal player_shooting(player, direction)
signal player_reload(player)

signal player_gain_hp(player, amount)
signal player_get_damage(player, amount)
signal player_gain_xp(player, amount)
signal player_level_up(player, new_level)
signal player_dead(player)

# Inicia y retorna un player de los que estan creados en el
# DataManager.
func init_player(player_num : int) -> GPlayer:
	if player_num > DataManager.players.size():
		return null
	
	var player
	
	# Por algun motivo que la humanidad desconoce hay que
	# castear eso a int :S
	match int(DataManager.players[player_num].player_type):
		PlayerType.DORBOT:
			pass
		PlayerType.MATBOT:
			player = load("res://scenes/actors/players/matbot/Matbot.tscn").instance()
		PlayerType.PIXBOT:
			pass
		PlayerType.SERBOT:
			pass
	
	players.append(player)
	
	# Le asociamos la data del player con la data de juego
	player.data = DataManager.players[player_num]
	cad_players(player)
	
	if player.data.is_dead:
		player.data.revive()
	
	return player

# Siempre hay que llamar a esta funcion antes de salir del
# juego!!
func clear_players():
	players.clear()
	disconnect_player(current_player_connected)

# Conecta señales y desconecta señales si es que hay otro
# player
# Connect And Disconnect Players
func cad_players(_new_player : GPlayer, old_player = null):
	current_player_connected = _new_player
	
#	print("cad_players(): new_player: ", current_player_connected)
#	print("cad_players(): old_player: ", old_player)
	
	if not current_player_connected.is_connected("fire", self, "_on_player_fire"):
		connect_player(current_player_connected)
	
	if old_player and not old_player.is_connected("fire", self, "_on_player_fire"):
		disconnect_player(old_player)
	
func connect_player(player):
	player.connect("fire", self, "_on_player_fire", [player])
	player.connect("reload", self, "_on_player_reload", [player])
	
	player.data.connect("add_hp", self, "_on_add_hp", [player])
	player.data.connect("add_xp", self, "_on_add_xp", [player])
	player.data.connect("remove_hp", self, "_on_remove_hp", [player])
	player.data.connect("level_up", self, "_on_level_up", [player])
	player.data.connect("dead", self, "_on_dead", [player])
		
func disconnect_player(player):
	player.disconnect("fire", self, "_on_player_fire")
	player.disconnect("reload", self, "_on_player_reload")
	
	player.data.disconnect("add_hp", self, "_on_add_hp")
	player.data.disconnect("add_xp", self, "_on_add_xp")
	player.data.disconnect("remove_hp", self, "_on_remove_hp")
	player.data.disconnect("level_up", self, "_on_level_up")
	player.data.disconnect("dead", self, "_on_dead")

# Devuelve la instancia de el player actual (GPlayer)
func get_current_player():
	if players.size() > 0:
		return players[DataManager.get_current_player()]

func get_next_player():
	var next_player_num = DataManager.get_next_player()
	
	if next_player_num <= players.size() - 1:
		var next_player = players[next_player_num]
		cad_players(next_player, get_current_player())
		# Setea el proximo player como actual
		DataManager.set_next_player()
		emit_signal("player_changed", next_player)
	
		return next_player
	else:
		return get_current_player()

func _on_dead(player):
	emit_signal("player_dead", player)

func _on_player_fire(direction, player):
	emit_signal("player_shooting", player, direction)

func _on_player_reload(player):
	emit_signal("player_reload", player)

func _on_add_hp(amount, player):
	emit_signal("player_gain_hp", player, amount)
	
func _on_remove_hp(amount, player):
	emit_signal("player_get_damage", player, amount)

func _on_add_xp(amount, player):
	emit_signal("player_gain_xp", player, amount)

func _on_level_up(new_level, player):
	emit_signal("player_level_up", player, new_level)

