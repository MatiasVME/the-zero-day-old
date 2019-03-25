tool
extends Navigation2D

export(bool) var update_on_start  : bool = true

export(String, FILE, "*.tres") var data_file_path setget set_data_file_path

signal data_file_path_changed

func _ready():
	if update_on_start :
		update_no_navegable_tiles()

func set_data_file_path(_path):
	data_file_path = _path
	emit_signal("data_file_path_changed")

func update_no_navegable_tiles():
	if not has_node("Terrain") : return
	var tiles_pos = get_tiles_pos_list()
	for tile_pos in tiles_pos:
		print("=========")
		var current_tile_name = $Terrain.tile_set.tile_get_name($Terrain.get_cell(tile_pos.x, tile_pos.y))
		var opposite_tile = $Terrain.tile_set.find_tile_by_name(current_tile_name + "_not_navigable")
		var autotile_coord = $Terrain.get_cell_autotile_coord(tile_pos.x, tile_pos.y)
		$Terrain.set_cell(tile_pos.x, tile_pos.y, opposite_tile, false, false, false, autotile_coord)
	

func get_tiles_pos_list():
	var file = File.new()
	file.open(data_file_path, 1)
	var tiles_pos = file.get_var() as Array
	file.close()
	return tiles_pos