extends Node

func _ready():
	MusicManager.play(MusicManager.Music.SPACE_BATTLE)
	
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(320, 320)
	$YSort.add_child(player)
	player.enable_player()
	
	$HUD.add_actor_to_hud(player)
	$HUD.set_hud_actor(player)
	$GameCamera.following = player
	player.game_camera = $GameCamera
	
	var item4 = Factory.ItemInWorldFactory.create_normal_ammo()
	item4.global_position = Vector2(531, 242)
	$YSort.add_child(item4)

	var item5 = Factory.ItemInWorldFactory.create_normal_ammo()
	item5.global_position = Vector2(532, 243)
	$YSort.add_child(item5)

	var item7 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item7.global_position = Vector2(532, 243)
	$YSort.add_child(item7)

	var item8 = Factory.ItemInWorldFactory.create_plasma_ammo()
	item8.global_position = Vector2(532, 238)
	$YSort.add_child(item8)
