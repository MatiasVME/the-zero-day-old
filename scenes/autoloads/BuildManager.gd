extends Node

signal prepare_to_build(tilemap, build_id, actor)

func prepare_to_build(build_id):
	var map = get_tree().get_nodes_in_group("Map")
	var player = PlayerManager.get_current_player()
	
	# A veces player es null, esto esta bien cuando
	# se empieza el juego y se quiere empezar colocando
	# el core.
	if map:
		emit_signal("prepare_to_build", map, build_id, player)
	else:
		print("Map not exist")
		
func get_constructibles():
	pass
	
func get_constructible(build_id):
	match build_id:
		Enums.StructureType.CORE:
			return load("res://scenes/structures/core/Core.tscn").instance()
		Enums.StructureType.COMMON_FACTORY:
			return load("res://scenes/structures/factories/common/CommonFactory.tscn").instance()
		Enums.StructureType.LIGHT_TURRET:
			return load("res://scenes/structures/turrets/LightTurret/LightTurret.tscn").instance()
			
func get_build_texture_button(build_id):
	match build_id:
		Enums.StructureType.COMMON_FACTORY:
			return [
				preload("res://scenes/hud/build_menu/BuildsImages/CF-Normal.png"),
				preload("res://scenes/hud/build_menu/BuildsImages/CF-Pressed.png"),
				preload("res://scenes/hud/build_menu/BuildsImages/CF-Hover.png"),
				preload("res://scenes/hud/build_menu/BuildsImages/CF-Disabled.png")
			]
	
func get_structure_box(build_id):
	var structure_box
	
	match build_id:
		Enums.StructureType.COMMON_FACTORY:
			structure_box = ZDStructureBox.new()
			structure_box.time_to_open = 3.0
			structure_box.structure_box_type = Enums.StructureType.COMMON_FACTORY
			return structure_box

func get_structure_box_in_world(build_id):
	var structure_box = get_structure_box(build_id)
	var structure_box_in_world
	
	match build_id:
		Enums.StructureType.COMMON_FACTORY:
			structure_box_in_world = load("res://scenes/items/structure_boxes/factories/common/CommonFactoryBoxInWorld.tscn").instance()
			structure_box_in_world.setup(structure_box)
			return structure_box_in_world
