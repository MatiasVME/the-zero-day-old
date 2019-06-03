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
	noise.lacunarity = config["Lacunarity"]
	
	match result_type:
		ResultType.ARRAY: return _create_array_map(config, noise)
	
static func _create_array_map(config, noise):
	var result = []

	for y in config["ChunkMapSize"].y:
		var row = []
		
		for x in config["ChunkMapSize"].x:
			row.append(_create_chunk(config, noise, Vector2(x, y)))
		
		result.append(row)
		
	return result
	
static func _create_chunk(config, noise, position):
	var result = {
		"Position" : position,
		"Data" : _get_chunk(config, noise, position)
	}
	return result

static func _get_chunk(config, noise, position : Vector2):
	var result = []
	
	for y in config["ChunkSize"]:
		var row = []
		
		for x in config["ChunkSize"]:
			row.append(_get_block(config, noise, Vector2(x + position.x * config["ChunkSize"], y + position.y * config["ChunkSize"])))
			
		result.append(row)
	
	return result
	
static func _get_block(config, noise, position : Vector2) -> String:
	var pos_value = noise.get_noise_2dv(position)
	
	var blocks_osccurrence_keys = config["BlocksOccurrence"].keys()
	var blocks_osccurrence_values = config["BlocksOccurrence"].values()
	
	for i in config["BlocksOccurrence"].size():
		if pos_value < blocks_osccurrence_values[i]:
			return blocks_osccurrence_keys[i]
	
	return ""
	