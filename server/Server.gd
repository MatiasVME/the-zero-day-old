extends SceneTree

var port = 1234 # Temporal port
var max_players = 8

var players_id = []

func _init():
	print("Hola!!")
	connect("connected_to_server", self, "_connected_ok")

#func create_host():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(port, max_players)
	network_peer = host
	
func _connected_ok():
	print("Conectado :D")