extends Node2D

var camera

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(-224, 288)
	add_child(player)
	player.enable_player()
	
#	var player2 = PlayerManager.init_player(0)
#	player2.global_position = Vector2(-224, 320)
#	add_child(player2)
	
	$GameCamera.following = player
	$GameCamera.mode = $GameCamera.Mode.FOLLOW
	
	$HUD.add_actor_to_hud(player)
	$HUD.set_hud_actor(player)
	
	$NormalChest.add_item(Factory.ItemFactory.create_rand_distance_weapon())
	$NormalChest.add_item(Factory.ItemFactory.create_rand_distance_weapon())
	$NormalChest.add_item(Factory.ItemFactory.create_rand_distance_weapon())
	$NormalChest.test()
	$NormalChest2.test()
	
	var item1 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item1.global_position = Vector2(200, 104)
	add_child(item1)
	
	var item2 = Factory.ItemInWorldFactory.create_normal_ammo()
	item2.global_position = Vector2(200, 101)
	add_child(item2)
	
	var item3 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item3.global_position = Vector2(201, 100)
	add_child(item3)
	
	var item4 = Factory.ItemInWorldFactory.create_normal_ammo()
	item4.global_position = Vector2(200, 101)
	add_child(item4)
	
	var item5 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item5.global_position = Vector2(201, 100)
	add_child(item5)

	var item6 = Factory.ItemInWorldFactory.create_normal_ammo()
	item6.global_position = Vector2(201, 100)
	add_child(item6)
	
	var item9 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item9.global_position = Vector2(200, 104)
	add_child(item9)
	
#	Factory.ItemPackFactory.test()