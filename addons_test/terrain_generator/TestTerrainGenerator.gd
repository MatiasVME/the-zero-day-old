extends Node2D

func _ready():
	var map = $TerrainGenerator.create_terrain(
		$TerrainGenerator.TerrainType.MAP,
		$TerrainGenerator.get_config($TerrainGenerator.TerrainType.MAP),
		$TerrainGenerator.ResultType.ARRAY
	)
	
	