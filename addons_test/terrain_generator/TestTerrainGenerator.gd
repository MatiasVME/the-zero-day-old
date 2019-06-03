extends Node2D

const RECT_SIZE = 5
const CHUNK_SIZE = RECT_SIZE * 16

export (Color) var water
export (Color) var grass
export (Color) var dirt
export (Color) var sand

var map

func _ready():
	map = $TerrainGenerator.create_terrain(
		$TerrainGenerator.TerrainType.MAP,
		$TerrainGenerator.get_config($TerrainGenerator.TerrainType.MAP),
		$TerrainGenerator.ResultType.ARRAY
	)

func _process(delta):
	update()
	
func _draw():
	var color
	var origin = Vector2()
	
	var chunk_origin = Vector2()
	
	for m in map.size():
		for chunk in map[m]:
			for row in chunk["Data"]:
				for block in row:
					match block:
						"Water": color = water
						"Grass": color = grass
						"Dirt": color = dirt
						"Sand": color = sand
					draw_rect(
						Rect2(origin.x, origin.y, RECT_SIZE, RECT_SIZE),
						color
					)
					
					origin.x += RECT_SIZE
				origin.y += RECT_SIZE
				origin.x = 0
			chunk_origin.x += CHUNK_SIZE
		chunk_origin.y += CHUNK_SIZE
		chunk_origin.x = 0
					
	
	
	
	
	