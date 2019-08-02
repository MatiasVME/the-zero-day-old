extends Navigation2D

# Mapa el cual contendrá todas las navegaciones,
# y colisiones
var not_nav_map
# Terreno
var terrain_map
# El resto de mapas
var other_maps

func _ready():
	# Obtenemos el mapa principal, en este caso
	# terrain
	not_nav_map = get_children()[0]
	terrain_map = get_children()[1]
	other_maps = get_other_maps(not_nav_map)
	
#	create_not_navigable()
	
# map_exception no se añadirá a la lista
func get_other_maps(map_exception1):
	var other_maps := []
	
	for posible_map in get_children():
		if posible_map is TileMap and not (posible_map == map_exception1):
			other_maps.append(posible_map)
			
	return other_maps

func create_not_navigable():
#	for other_map in other_maps:
#		var x := 0
#		var y := 0
#
#		while y <= other_map.get_used_rect().size.y - 1:
#			x = 0
#
#			while x <= other_map.get_used_rect().size.x - 1:
#				if is_instance_valid(other_map.tile_set.tile_get_navigation_polygon(other_map.get_cell(x, y))):
#					nav_map.tile_set.tile_set_navigation_polygon(nav_map.get_cell(x, y), other_map.tile_set.tile_get_navigation_polygon(other_map.get_cell(x, y)))
#					print(x, " - ", y, " - ", other_map.tile_set.tile_get_navigation_polygon(other_map.get_cell(x, y)))
#				x += 1
#			y += 1

	var not_nav_tile_set = TileSet.new()
#	print("not_nav_tile_set: ", not_nav_tile_set)
	not_nav_map.tile_set = not_nav_tile_set
#	print("not_nav_map.tile_set", not_nav_map.tile_set)
	
	# Navigable (0)
	#
	
	not_nav_map.tile_set.create_tile(0)
	
	var nav_poligon = NavigationPolygon.new()
	var vertices = [
		Vector2(0, 0), 
		Vector2(16, 0),
		Vector2(16, 16),
		Vector2(0, 16),
		Vector2(0, 0)
	]
	
	nav_poligon.set_vertices(vertices)
	
	not_nav_map.tile_set.tile_set_navigation_polygon(0, nav_poligon)
	
	# Not navigable (1)
	#
	
	not_nav_map.tile_set.create_tile(1)
	
	var shape = RectangleShape2D.new()
	shape.extents.x = 8
	shape.extents.y = 8
	
	not_nav_map.tile_set.tile_set_shape(1, 0, shape)
	
	# Pasar los navigation polygon y colisiones de
	# los mapas a not_nav_map
	for other_map in other_maps:
		var x := 0
		var y := 0

		while y <= other_map.get_used_rect().size.y - 1:
			x = 0
			
			while x <= other_map.get_used_rect().size.x - 1:
				var current_cell = other_map.get_cell(x, y)
				
				if current_cell != TileMap.INVALID_CELL:
					# Consultar si esta celda actual contien navigation polygon,
					# si es que lo contiene asignarle una navegación a 
					# not_nav_map
					if other_map.tile_set.tile_get_navigation_polygon(current_cell) is NavigationPolygon:
						not_nav_map.set_cell(x, y, 0)
						print("Tiene navigation")
					
					# Y si contiene una colision asígnarle una colision a
					# not_nav_map
					elif other_map.tile_set.tile_get_shape(current_cell, 0) is Shape2D:
						not_nav_map.set_cell(x, y, 1)
						print("Tiene colision: ", other_map.tile_set.tile_get_shape(current_cell, 0))
					
					pass
				else:
					break
				x += 1
			y += 1
	