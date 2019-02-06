extends SceneTree

var port = 1234 # Temporal port
var max_players = 8

var players_id = []

func _init():
	print("Hola!!")
	connect("connected_to_server", self, "_connected_ok")
	
	var host = NetworkedMultiplayerENet.new()
	host.create_client("127.0.0.1", 1234)
	self.network_peer = host
	
func _connected_ok():
	print("Conectado :D [Client]")