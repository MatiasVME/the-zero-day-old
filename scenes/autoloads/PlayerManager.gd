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

signal player_changed(new_player)
signal player_shooting(player, direction)
signal player_reload

signal player_gain_hp(player, amount)
signal player_get_damage(player, amount)
signal player_gain_xp(player, amount)
signal player_level_up(player, new_level)

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
	
	return player

# Conecta señales y desconecta señales si es que hay otro
# player
# Connect And Disconnect Players
func cad_players(new_player : GPlayer, old_player = null):
	if not new_player.is_connected("fire", self, "_on_player_fire"):
		new_player.connect("fire", self, "_on_player_fire", [new_player])
		new_player.connect("reload", self, "_on_player_reload")
		
		new_player.data.connect("add_hp", self, "_on_add_hp", [new_player])
		new_player.data.connect("add_xp", self, "_on_add_xp", [new_player])
		new_player.data.connect("remove_hp", self, "_on_remove_hp", [new_player])
		new_player.data.connect("level_up", self, "_on_level_up", [new_player])
		
	if old_player and not old_player.is_connected("fire", self, "_on_player_fire"):
		old_player.disconnect("fire", self, "_on_player_fire")
		old_player.disconnect("reload", self, "_on_player_reload")
		
		old_player.data.disconnect("add_hp", self, "_on_add_hp")
		old_player.data.disconnect("add_xp", self, "_on_add_xp")
		old_player.data.disconnect("remove_hp", self, "_on_remove_hp")
		old_player.data.disconnect("level_up", self, "_on_level_up")

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
	
func _on_player_fire(direction, player):
	emit_signal("player_shooting", player, direction)

func _on_player_reload():
	emit_signal("player_reload")

func _on_add_hp(amount, player):
	emit_signal("player_gain_hp", player, amount)
	
func _on_remove_hp(amount, player):
	emit_signal("player_get_damage", player, amount)

func _on_add_xp(amount, player):
	emit_signal("player_gain_xp", player, amount)

func _on_level_up(new_level, player):
	emit_signal("player_level_up", player, new_level)

