extends Node

enum Build {
	LIGHT_TURRET
}

signal prepare_to_build(tilemap, build_id, actor)

func prepare_to_build(build_id):
	var map = get_tree().get_nodes_in_group("Map")
	var player = PlayerManager.get_current_player()
	
	if map and player:
		emit_signal("prepare_to_build", map, build_id, player)
	else:
		print("Map or player not exist")
	
func get_constructibles():
	pass
	
func get_constructible(build_id):
	match build_id:
		Build.LIGHT_TURRET:
			return load("res://scenes/structures/turrets/LightTurret/LightTurret.tscn").instance()
			
func get_build_textures(build_id):
	match build_id:
		Build.LIGHT_TURRET:
			return [
				preload("res://scenes/hud/build_menu/BuildsImages/LightTurret-Normal.png"),
				preload("res://scenes/hud/build_menu/BuildsImages/LightTurret-Pressed.png"),
				preload("res://scenes/hud/build_menu/BuildsImages/LightTurret-Hover.png")
			]
	
func get_build_texture_for_terrain(build_id):
	match build_id:
		Build.LIGHT_TURRET:
			return preload("res://scenes/actors/turrets/common-turret/images/LightTurret.png")





