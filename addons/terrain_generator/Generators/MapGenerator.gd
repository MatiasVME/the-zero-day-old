extends Object

class_name MapGenerator

enum ResultType {
	ARRAY,
	TILEMAP
}

static func create(config, result_type):
	var noise = OpenSimplexNoise.new()
	noise.seed = config["Seed"]
	noise.octaves = config["Octaves"]
	noise.period = config["Period"]
	noise.persistence = config["Persistence"]
#	noise.lacunarity = config["Lacunarity"]
	print("Noise.lacunarity ", noise.lacunarity)
	
	match result_type:
		ResultType.ARRAY: return _create_array(config, noise)
	
static func _create_array(config, noise):
#	print("Config: ", config)
	var result = []

	for y in config["ChunkMapSize"].y:
		var row = []
		
		for x in config["ChunkMapSize"].x:
			row.append(_create_chunk(config, noise, Vector2(x, y)))
		
		result.append(row)

#	for y in size:
#		var  = 
#
#		for x in size:
#			arr.append(noise.get_noise_2dv(Vector2(x, y)))
#
#		result.append(arr)
#
#	return result
	
static func _create_chunk(config, noise, position):
	var result = {
		"Position" : position,
		"Biome" : _get_biome(config, noise, position),
		"Data" : {}
	}
	print(result)
	
static func _get_biome(config, noise, position):
#	print(config["Biomes"].size())
	var biomes = config["Biomes"].keys()
	
	for biome_num in config["Biomes"].size():
#	for biome in config["Biomes"].values():
		var e = noise.get_noise_2dv(position)
		print(e)
#		print(config["Biomes"][biome_num])
#		print(e)
		
		if e < config["Biomes"][biomes[biome_num]]["Occurrence"]:
			return biomes[biome_num]
	
	
	
	
	