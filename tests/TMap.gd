extends Navigation2D

func _ready():
	for i in $Enviroment.tile_set.get_tiles_ids():
#		navpoly_add(
#			$Enviroment.tile_set.tile_get_navigation_polygon(i),
#			$Enviroment.tile_set.tile_get_shape_transform(0, 0)
#		)
		print(i)
	pass
