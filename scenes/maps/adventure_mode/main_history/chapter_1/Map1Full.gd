extends Node2D

var camera

func _ready():
	var player = PlayerManager.init_player(0)
	player.global_position = Vector2(120, 152)
	add_child(player)
	player.enable_player()
	
	$GameCamera.following = player
	$GameCamera.mode = $GameCamera.Mode.FOLLOW
	
	$HUD.add_actor_to_hud(player)
	# Con esto el hud tiene acceso al player
	# y el player tiene acceso al hud
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
	
	var ammo3 = Factory.ItemInWorldFactory.create_normal_ammo(32)
	ammo3.global_position = Vector2(296, 272)
	add_child(ammo3)
	
	var ammo4 = Factory.ItemInWorldFactory.create_normal_ammo(32)
	ammo4.global_position = Vector2(544, 592)
	add_child(ammo4)
	
	var weapon2 = Factory.ItemInWorldFactory.create_rand_distance_weapon(2, 1, 1)
	weapon2.global_position = Vector2(391, 1224)
	add_child(weapon2)
	