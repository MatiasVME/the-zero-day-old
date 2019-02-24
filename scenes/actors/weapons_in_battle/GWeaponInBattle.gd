extends Node2D

# Normalmente es un PHWeapon pero a veces puede ser
# null
var data

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

# Puede recibir un PHWeapon o un null
func set_weapon(weapon):
	data = weapon
	
	if data:
		$Sprite.texture = load(data.texture_path)
	else:
		$Sprite.texture = null
	
	emit_signal("weapon_added", data)
	set_physics_process(true)

func remove_weapon():
	data = null
	$Sprite.texture = null
	emit_signal("weapon_removed")