extends Node

# Mapa el cual contendrá todas las navegaciones,
# y colisiones
var nav_map
# El resto de mapas
var other_maps

func _ready():
	# Obtenemos el mapa principal, en este caso
	# terrain
	nav_map =$Navigation/NavigationMap
	other_maps = $MapLayers.get_children()
	
	adjust_size_maps()
	create_navigable()

# Ajusta el tamaño de los mapas para que todos tengan
# el mismo tamaño, en este caso se basa en terrain
func adjust_size_maps():
	var map_size = $MapLayers/Terrain.get_used_rect().size

	$MapLayers/Structures.set_cellv(Vector2.ZERO, 0)
	$MapLayers/Enviroment.set_cellv(Vector2.ZERO, 0)
	$MapLayers/Terrain.set_cellv(Vector2.ZERO, 0)
	$Navigation/NavigationMap.set_cellv(Vector2.ZERO, 0)
	
	$MapLayers/Structures.set_cellv(map_size, 0)
	$MapLayers/Enviroment.set_cellv(map_size, 0)
	$MapLayers/Terrain.set_cellv(map_size, 0)
	$Navigation/NavigationMap.set_cellv(map_size, 0)
	
# map_exception no se añadirá a la lista
func get_other_maps(map_exception1):
	var other_maps := []
	
	for posible_map in get_children():
		if posible_map is TileMap and not (posible_map == map_exception1):
			other_maps.append(posible_map)
			
	return other_maps

func create_navigable():
	var x = 0
	var y = 0
	
	# Hacer que todo el mapa sea navegable por defecto 
	# y ir añadiendole not navigable
	while y <= nav_map.get_used_rect().size.y - 1:
		x = 0
		while x <= nav_map.get_used_rect().size.x - 1:
			nav_map.set_cell(x, y, 1)
			x += 1
		y += 1
	
	# Ingresar las sonas no navegables cuando existan
	x = 0
	y = 0
	
	for other_map in other_maps:
		x = 0
		y = 0
	
		while y <= nav_map.get_used_rect().size.y - 1:
			x = 0
			while x <= nav_map.get_used_rect().size.x - 1:
				var current_cell = other_map.get_cell(x, y)
				
				if other_map.tile_set.tile_get_shape(current_cell, 0) is Shape2D:
					nav_map.set_cell(x, y, 0)
				x += 1
			y += 1