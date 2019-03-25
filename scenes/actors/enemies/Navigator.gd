extends Node

export(float) var time_to_update_path = 1.3

var time_current = 0.0

var nav : Navigation2D

var can_navigate : bool = false

var navigation_path : PoolVector2Array

var current_index : int = 0

var out_of_index : bool = false

func _ready():
	if get_parent().get_parent().has_node("Nav"):
		nav = get_parent().get_parent().get_node("Nav")
		can_navigate = true

func update_navigation_path(target_pos):
	navigation_path = calcule_navigation_path(target_pos)
#	get_parent().get_parent().re_draw_paths(navigation_path)
	time_current = 0
	current_index = 0
	out_of_index = false

func calcule_navigation_path(target_pos):
	#var t = OS.get_ticks_usec()
	var path = nav.get_simple_path(get_parent().global_position, target_pos)
	#print(OS.get_ticks_usec() - t)
	path.remove(0)
	return path

func get_current_point():
	return navigation_path[current_index]

func next_index():
	current_index += 1
	if current_index >= navigation_path.size():
		out_of_index = true