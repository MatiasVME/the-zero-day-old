extends Node2D

var camera

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(120, 152)
	add_child(player)
	player.enable_player()
	
	camera = CameraManager.set_camera_game()
	camera.following = player
	camera.mode = camera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)
	
	var weapon = Factory.ItemInWorldFactory.create_from_item(Factory.ItemFactory.create_rand_distance_weapon(1, 1, 1, 1))
	weapon.global_position = Vector2(120, 94)
	add_child(weapon)
	
	var ammo1 = Factory.ItemInWorldFactory.create_normal_ammo(32)
	ammo1.global_position = Vector2(200, 94)
	add_child(ammo1)
	
	var ammo2 = Factory.ItemInWorldFactory.create_normal_ammo(32)
	ammo2.global_position = Vector2(200, 152)
	add_child(ammo2)
	
	