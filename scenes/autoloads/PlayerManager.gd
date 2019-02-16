"""
PlayerManager.gd

Gestiona las instancias de los players.
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

# Inicia y retorna un player de los que estan creados en el
# DataManager.
func init_player(player_num : int) -> GPlayer:
	if player_num > DataManager.players.size():
		return null
	
	var player
	
	match DataManager.players[player_num].player_type:
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
	
	return player
	
func get_current_player():
	if players.size() > 0:
		return players[DataManager.get_current_player()]