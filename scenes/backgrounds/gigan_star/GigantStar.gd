extends ParallaxBackground

func _process(delta):
	scroll_base_offset.x -= delta * 10
	scroll_base_offset.y -= delta * 5
	
	
