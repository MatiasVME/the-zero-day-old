extends Node2D

func _ready():
	pass

func _physics_process(delta):
	if $Sprite.rotation_degrees < 90 and $Sprite.rotation_degrees > -90:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true
	
	if $Sprite.rotation_degrees < 0 or $Sprite.rotation_degrees > 360:
		$Sprite.rotation_degrees = 0
	
	$Sprite.look_at(get_global_mouse_position())