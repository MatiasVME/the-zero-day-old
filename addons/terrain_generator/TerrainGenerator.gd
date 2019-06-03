tool

extends Node

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
	ARRAY,
	TILEMAP
}

# Para crear un terreno primero se debe obtener la configuracion
# y configurar los parametros para el terreno. Cada terreno
# tiene distintas opciones.
func get_config(terrain_type):
	match terrain_type:
		TerrainType.CAVE:
			return _get_cave_config()
		TerrainType.DUNGEON:
			return _get_dungeon_config()
		TerrainType.MAP:
			return _get_map_config()
	
func create_terrain(terrain_type, config, result_type):
	match terrain_type:
		TerrainType.CAVE:
#			_create_cave_terrain(result_type)
			pass
		TerrainType.DUNGEON:
#			_create_dungeon_terrain(result_type)
			pass
		TerrainType.MAP:
			_create_map_terrain(config, result_type)

func _create_map_terrain(config, result_type):
	MapGenerator.create(config, result_type)

func _get_cave_config():
	pass
	
func _get_dungeon_config():
	pass
	
func _get_map_config():
	return {
		"Seed" : 1234,
		"ChunkSize" : 16,
		"ChunkMapSize" : Vector2(4, 4),
		"Octaves" : 4,
		"Period" : 40,
		"Persistence" : 0.9,
		"Lacunarity" :  2,
		"Biomes" : {
			"Ocean" : {
				"Occurrence" : 0.1,
				"Distribution" : {
					"Water" : 1
				}
			},
			"Beach" : {
				"Occurrence" : 0.3,
				"Distribution" : {
					"Water" : 0.6,
					"Sand" : 1
				}
			},
			"Grassland" : {
				"Occurrence" : 1,
				"Distribution" : {
					"Grass" : 0.6,
					"Water" : 0.7,
					"Dirt" : 0.9,
					"Sand" : 1,
				}
			}
		}
	}
	
	
	
	
	