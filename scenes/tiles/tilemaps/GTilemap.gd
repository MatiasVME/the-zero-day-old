extends Navigation2D

var nav_map

func _ready():
	nav_map = get_children()[0]
	print(nav_map.name)
