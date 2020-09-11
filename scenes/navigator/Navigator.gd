extends Node

class_name Navigator

export (float) var time_to_update_path = 1.5

var time_current = 0.0

# Se usa para un navigator2d
onready var nav = get_tree().get_nodes_in_group("Navigation")

var nav_map

var can_navigate := false

var navigation_path : PoolVector2Array

var current_index := 0

var out_of_index := false

func _ready():
	if nav.size() > 0:
		nav = nav[0]
		nav_map = nav.get_node("Terrain")
		can_navigate = true

func update_path(target_pos):
	navigation_path = calculate_path(target_pos)
	time_current = 0
	current_index = 0
	out_of_index = false
	
	return navigation_path

func calculate_path(target_pos):
	var path = nav.get_simple_path(get_parent().global_position, target_pos, false)
	if path.size() > 1:
		path.remove(0)
	else:
		path = nav.get_simple_path(nav.get_closest_point(get_parent().global_position), target_pos, false)
	
	if path[-1] == target_pos:
		print_debug("EQUAL")
	else:
		print_debug("NO EQUAL")	
	
	return path

func get_current_point():
	if navigation_path.size() > 0:
		return navigation_path[current_index]

func next_index():
	if out_of_index: 
		return
		
	current_index += 1
	if current_index >= navigation_path.size() -1:
		out_of_index = true
		current_index = navigation_path.size()-1

func need_next_point(current_position):
	if out_of_index or navigation_path.size() == 0:
		return false
		
	var current_point = navigation_path[current_index]
	var next_point = navigation_path[current_index + 1]
	
	var distance_between_points = current_point.distance_to(next_point)
	var distance_to_next_point = current_position.distance_to(next_point)
	
	# Si la distancia entre los puntos es mayor a la distancia al siguiente punto,
	# significa que se paso del punto actual, por lo que necesita ir al siguiente punto.
	if distance_between_points >= distance_to_next_point:
		return true
	return false
	

func compare_points(current_pos):
	if out_of_index:
		return false
	var vec_to_point1 = navigation_path[current_index] - current_pos
	var vec_to_point2 = navigation_path[current_index + 1] - navigation_path[current_index] 
	
	var angle = vec_to_point1.angle_to(vec_to_point2)
	return angle > -0.7 or angle < 0.7

func has_points():
	return navigation_path.size() > 0

func tile_is_navigable(x, y):
	var tile_set_id = nav_map.get_cell(x,y)
	var autotile_coord = nav_map.get_cell_autotile_coord(x,y)
	
	var polygon = nav_map.get_tileset().autotile_get_navigation_polygon(tile_set_id, autotile_coord)
	
	return polygon != null
