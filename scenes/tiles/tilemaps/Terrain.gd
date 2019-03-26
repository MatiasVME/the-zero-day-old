extends TileMap

onready var game_camera = get_tree().get_nodes_in_group("GameCamera")

func _ready():
	# Obtenemos la camara si es que existe
	if game_camera.size() > 0: 
		game_camera = game_camera[0]
	else:
		return
	
	var top_left = map_to_world(Vector2(0, 0))
	var bottom_right = map_to_world(get_used_rect().size)
	print(top_left)
	print(bottom_right)
	
	game_camera.limit_left = top_left.x
	game_camera.limit_top = top_left.y
	game_camera.limit_right = bottom_right.x - 8 * 16
	game_camera.limit_bottom = bottom_right.y - 9 * 16