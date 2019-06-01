extends Node2D

func _ready():
	var map_config = $TerrainGenerator.get_config()
	var map = $TerrainGenerator.create_terrain()