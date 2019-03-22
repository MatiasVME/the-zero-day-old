extends Node2D

var camera

var paths

var gluton_pos

func _ready():
	var player = PlayerManager.init_player(0)
	add_child(player)
	player.position = $PlayerSpawn.position
	player.enable_player()
	
#	
	camera = CameraManager.set_camera_game()
	camera.following = player
	camera.mode = camera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)

func re_draw_paths(_paths):
	paths = _paths
	print(paths)
	if paths.size() > 0:
		update()


func _draw():
	
	if paths and paths.size() > 0:
		for point in paths:
			draw_circle(point, 4, Color(1, 0, 0))