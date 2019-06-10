extends Node

export(float) var time_to_update_path = 1.3

var time_current = 0.0

# Se usa para un navigator2d
onready var nav = get_tree().get_nodes_in_group("Map")

var can_navigate : bool = false

var navigation_path : PoolVector2Array

var current_index : int = 0

var out_of_index : bool = false

func _ready():
	if nav.size() > 0:
		nav = nav[0]
		can_navigate = true

func update_navigation_path(target_pos):
	navigation_path = calcule_navigation_path(target_pos)
	time_current = 0
	current_index = 0
	out_of_index = false

func calcule_navigation_path(target_pos):
	var path = nav.get_simple_path(get_parent().global_position, target_pos)
	if path.size() > 1:
		path.remove(0)
	else:
		path = nav.get_simple_path(nav.get_closest_point(get_parent().global_position), target_pos)

	return path

func get_current_point():
	return navigation_path[current_index]

func next_index():
	current_index += 1
	if current_index >= navigation_path.size():
		out_of_index = true