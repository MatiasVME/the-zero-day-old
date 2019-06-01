tool

extends EditorPlugin

class_name TerrainGenerator, "icon.png"

# Es para seleccionar el tipo de terreno y usar el algoritmo
# adecuado para cada tipo
enum TerrainType {
	CAVE,
	DUNGEON,
	MAP
}

# Es para seleccionar el tipo de resultado, como podria ser
# una matriz o vector multidimencional, o un tilemap.
enum ResultType {
	VECTOR,
	TILEMAP
}

# Para crear un terreno primero se debe obtener la configuracion
# y configurar los parametros para el terreno. Cada terreno
# tiene distintas opciones.
func get_config(terrain_type):
	match terrain_type:
		TerrainType.CAVE:
			pass
		TerrainType.DUNGEON:
			pass
		TerrainType.MAP:
			pass
	
func create_terrain(terrain_type, config, result_type):
	pass