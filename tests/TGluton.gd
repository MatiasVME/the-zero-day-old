extends Node

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(420, 290)
	add_child(player)
	player.enable_player()
	
	$HUD.add_actor_to_hud(player)
	$HUD.set_hud_actor(player)
	$GameCamera.following = player
	player.game_camera = $GameCamera
	
	var item1 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item1.global_position = Vector2(400, 201)
	add_child(item1)
	
	var item2 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item2.global_position = Vector2(400, 202)
	add_child(item2)
	
	var item3 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item3.global_position = Vector2(400, 203)
	add_child(item3)
	
	var item4 = Factory.ItemInWorldFactory.create_normal_ammo()
	item4.global_position = Vector2(405, 204)
	add_child(item4)
	
	var item5 = Factory.ItemInWorldFactory.create_normal_ammo()
	item5.global_position = Vector2(404, 204)
	add_child(item5)
	
	var item6 = Factory.ItemInWorldFactory.create_normal_ammo()
	item6.global_position = Vector2(403, 204)
	add_child(item6)
	
	var item7 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item7.global_position = Vector2(402, 204)
	add_child(item7)
	
	var item8 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item8.global_position = Vector2(401, 204)
	add_child(item8)
	
	var item9 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
	item9.global_position = Vector2(401, 404)
	add_child(item9)
	
	var item10 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
	item10.global_position = Vector2(401, 404)
	add_child(item10)
	
	var item11 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
	item11.global_position = Vector2(401, 404)
	add_child(item11)
	
	var item12 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
	item12.global_position = Vector2(401, 404)
	add_child(item12)
	
	var item13 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
	item13.global_position = Vector2(401, 404)
	add_child(item13)