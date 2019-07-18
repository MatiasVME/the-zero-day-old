extends Node2D

# Normalmente es un PHWeapon pero a veces puede ser
# null
var data

# WeaponSprite RotationDegrees
var ws_rd = 0

var img_boxing1 = preload("res://scenes/actors/melee_attack/Images/boxing.png")

# Mobile
onready var game_camera = get_tree().get_nodes_in_group("GameCamera")
var mobile_selected_pos

signal weapon_added(weapon)
signal weapon_removed()

func _ready():
	if Main.is_mobile and game_camera.size() > 0:
		game_camera = game_camera[0]
		mobile_selected_pos = game_camera.get_node("MobileSelected/Pos")
	
func _process(delta):
	ws_rd = rotation_degrees
	
	if ws_rd > 90 and ws_rd < 270 or ws_rd < -90 and ws_rd > -270:
		$WeaponSprite.flip_v = true
	else:
		$WeaponSprite.flip_v = false
		
	if ws_rd < -360 or ws_rd > 360:
		rotation_degrees = 0
	
	if not Main.is_mobile:
		$Weapon.look_at(get_global_mouse_position())
	elif mobile_selected_pos:
		$Weapon.look_at(mobile_selected_pos.global_position)

# Puede recibir un PHMeleeWeapon o un null
func set_weapon(weapon = null):
	data = weapon
	
	if data and data is PHMeleeWeapon:
		$WeaponSprite.texture = load(data.texture_path)
	else:
		$WeaponSprite.texture = img_boxing1
	
	emit_signal("weapon_added", data)

func remove_weapon():
	data = null
	$WeaponSprite.texture = img_boxing1
	emit_signal("weapon_removed")

func _on_HitArea_body_entered(body):
	if body is GEnemy or body is GStructure:
		body.damage(PlayerManager.current_player.data.attack)
	elif body is GBullet:
		body.direction = body.direction.bounce(get_parent().global_position.normalized())