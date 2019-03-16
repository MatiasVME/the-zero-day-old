extends Node2D

var camera

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(-224, 288)
	add_child(player)
	player.enable_player()
	
	camera = CameraManager.set_camera_game()
	camera.following = player
	camera.mode = camera.Mode.FOLLOW
	
	$HUD.set_hud_actor(player)
	
	var item1 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item1.global_position = Vector2(200, 104)
	add_child(item1)
	
	var item4 = Factory.ItemInWorldFactory.create_test_ammo()
	item4.global_position = Vector2(200, 101)
	add_child(item4)
	
	var item5 = Factory.ItemInWorldFactory.create_test_ammo()
	item5.global_position = Vector2(201, 100)
	add_child(item5)
	
	var item6 = Factory.ItemInWorldFactory.create_test_ammo()
	item6.global_position = Vector2(201, 100)
	add_child(item6)
	
	var item7 = Factory.ItemInWorldFactory.create_test_ammo()
	item7.global_position = Vector2(201, 100)
	add_child(item7)
	
	var item8 = Factory.ItemInWorldFactory.create_test_ammo()
	item8.global_position = Vector2(201, 100)
	add_child(item8)
	
	var item9 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item9.global_position = Vector2(200, 104)
	add_child(item9)
	
	var item10 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item10.global_position = Vector2(200, 104)
	add_child(item10)
	
	var item11 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item11.global_position = Vector2(200, 104)
	add_child(item11)

#	Factory.ItemFactory.test()