extends TextureButton

var build_id setget set_build_id, get_build_id

# Recibe un BuildManager.Build el cual es el id
# para la estructura
func set_build_id(_build_id):
	build_id = _build_id
	
	var textures = BuildManager.get_build_textures(build_id)
	texture_normal = textures[0]
	texture_pressed = textures[1]
	texture_hover = textures[2]
	
func get_build_id():
	return build_id