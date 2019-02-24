extends Node2D

var data : PHWeapon

signal weapon_added(weapon)
signal weapon_removed()

func _physics_process(delta):
	if not data:
		set_physics_process(false)
		return
	
	if $Sprite.rotation_degrees < 90 and $Sprite.rotation_degrees > -90:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true
	
	if $Sprite.rotation_degrees < 0 or $Sprite.rotation_degrees > 360:
		$Sprite.rotation_degrees = 0
	
	$Sprite.look_at(get_global_mouse_position())
	
func set_weapon(weapon : PHWeapon):
	data = weapon
	
	if data:
		$Sprite.texture = load(data.texture_path)
	
	emit_signal("weapon_added", data)
	set_physics_process(true)

func remove_weapon():
	data = null
	$Sprite.texture = null
	emit_signal("weapon_removed")