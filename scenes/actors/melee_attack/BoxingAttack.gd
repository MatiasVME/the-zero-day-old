extends Node2D

# Normalmente es un PHWeapon pero a veces puede ser
# null
var data

# WeaponSprite RotationDegrees
var ws_rd = 0

signal weapon_added(weapon)
signal weapon_removed()

func _physics_process(delta):
	ws_rd = rotation_degrees
	
	if ws_rd > 90 and ws_rd < 270 or ws_rd < -90 and ws_rd > -270:
		$WeaponSprite.flip_v = true
	else:
		$WeaponSprite.flip_v = false
		
	if ws_rd < -360 or ws_rd > 360:
		rotation_degrees = 0
	
	look_at(get_global_mouse_position())

# Puede recibir un PHMeleeWeapon o un null
func set_weapon(weapon = null):
	data = weapon
	
	if data and data is PHMeleeWeapon:
		$WeaponSprite.texture = load(data.texture_path)
	else:
		$WeaponSprite.texture = load("res://scenes/actors/melee_attack/Images/boxing.png")
	
	emit_signal("weapon_added", data)

func remove_weapon():
	data = null
	$WeaponSprite.texture = load("res://scenes/actors/melee_attack/Images/boxing.png")
	emit_signal("weapon_removed")

func _on_HitArea_body_entered(body):
	if body is GEnemy:
		body.damage(1)
	elif body is GBullet:
		body.direction = body.direction.bounce(global_position.normalized())