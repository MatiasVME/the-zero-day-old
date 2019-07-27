extends Navigation2D

# Mapa el cual contendrá todas las navegaciones,
# y colisiones
var nav_map
# El resto de mapas
var other_maps

func _ready():
	# Obtenemos el mapa principal, en este caso
	# terrain
	nav_map = get_children()[0]
	other_maps = get_other_maps(nav_map)
	
	add_not_navigable_to_current_nav_map()
	
# map_exception no se añadirá a la lista
func get_other_maps(map_exception):
	var other_maps := []
	
	for posible_map in get_children():
		if posible_map is TileMap and posible_map != map_exception:
			other_maps.append(posible_map)
			
	return other_maps

func add_not_navigable_to_current_nav_map():
	for other_map in other_maps:
		var x := 0
		var y := 0
		
		while y <= other_map.tile_set.get_used_rect().size - 1:
			pass