extends Node

var multiplayer_on = false

var port = 1234 # Temporal port
var max_players = 8

var players_id = []
var player

func _ready():
	player = load("res://scenes/actors/players/matbot/Matbot.tscn")	
	get_tree().connect("connected_to_server", self, "_connected_ok")

func create_host():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(port, max_players)
	get_tree().set_network_peer(host)
 
	_connected_ok()

func join_host(ip):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, port)
	get_tree().set_network_peer(host)

func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id())
	register_player(get_tree().get_network_unique_id())
#	get_tree().get_root().get_node("Lobby").queue_free()
	multiplayer_on = true
	print("_connected_ok")
	
remote func register_player(id):
	var p = player.instance()
	p.set_network_master(id)
	p.name = str(id)
	get_tree().get_root().add_child(p)
	
	# if I'm the server I inform the new connected player about the others
	if get_tree().get_network_unique_id() == 1:
		if id != 1:
			for i in players_id:
				rpc_id(id, "register_player", i)
		players_id.append(id)