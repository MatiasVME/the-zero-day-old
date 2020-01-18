extends Node

func _ready():
	MusicManager.play(MusicManager.Music.JAZZ_OF_DEATH)
	
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(420, 300)
	$YSort.add_child(player)
	player.enable_player()
	
	$HUD.add_actor_to_hud(player)
	$HUD.set_hud_actor(player)
	$GameCamera.following = player
	player.game_camera = $GameCamera
	
	var item1 = Factory.ItemInWorldFactory.create_rand_distance_weapon()
	item1.global_position = Vector2(530, 241)
	$YSort.add_child(item1)
	

	var item4 = Factory.ItemInWorldFactory.create_normal_ammo()
	item4.global_position = Vector2(531, 242)
	$YSort.add_child(item4)

	var item5 = Factory.ItemInWorldFactory.create_normal_ammo()
	item5.global_position = Vector2(532, 243)
	$YSort.add_child(item5)
#
#	var item6 = Factory.ItemInWorldFactory.create_normal_ammo()
#	item6.global_position = Vector2(403, 454)
#	$YSort.add_child(item6)
#
	var item7 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item7.global_position = Vector2(532, 243)
	$YSort.add_child(item7)

	var item8 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item8.global_position = Vector2(532, 238)
	$YSort.add_child(item8)

	var item9 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
	item9.global_position = Vector2(529, 243)
	$YSort.add_child(item9)
#
#	var item10 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
#	item10.global_position = Vector2(401, 404)
#	$YSort.add_child(item10)
#
#	var item11 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
#	item11.global_position = Vector2(401, 404)
#	$YSort.add_child(item11)
#
#	var item12 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
#	item12.global_position = Vector2(401, 404)
#	$YSort.add_child(item12)
#
#	var item13 = Factory.ItemInWorldFactory.create_rand_melee_weapon()
#	item13.global_position = Vector2(401, 404)
#	$YSort.add_child(item13)
