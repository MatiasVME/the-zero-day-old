extends Node

# Mapa el cual contendrá todas las navegaciones,
# y colisiones
var nav_map
# El resto de mapas
var other_maps

func _ready():
	# Obtenemos el mapa principal, en este caso
	# terrain
	nav_map = $Navigation/Terrain
	other_maps = $MapLayers.get_children()