extends GStructure

onready var game_camera = get_tree().get_nodes_in_group("GameCamera")

func _init():
	structure_size = StructureSize.S3X3

func _ready():
	$Base.play("idle")
	StructurePanelManager.show_panel(StructurePanelManager.StructurePanel.CORE)
	
	if game_camera.size() > 0:
		game_camera = game_camera[0]
	else:
		print("Falta la GameCamera")
		game_camera = null
	
func init_player(player_name):
	var player
	
	match player_name:
		"Dorbot":
			player = PlayerManager.init_player(0)
			
	get_parent().add_child(player)
	player.position = position + Vector2(0, 30)
	player.enable_player()
	
	if game_camera:
		game_camera.following = player
		game_camera.mode = game_camera.Mode.FOLLOW