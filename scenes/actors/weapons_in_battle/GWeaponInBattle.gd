extends Node2D

# Normalmente es un PHWeapon pero a veces puede ser
# null
var data

# Mobile
onready var game_camera = get_tree().get_nodes_in_group("GameCamera")
var mobile_selected_pos

signal weapon_added(weapon)
signal weapon_removed()

func _ready():
	if Main.is_mobile and game_camera.size() > 0:
		game_camera = game_camera[0]
		mobile_selected_pos = game_camera.get_node("MobileSelected/Pos")
	
func _physics_process(delta):
	if not data:
		set_physics_process(false)
		return
	
	if $Sprite.rotation_degrees > 90 and $Sprite.rotation_degrees < 270 or $Sprite.rotation_degrees < -90 and $Sprite.rotation_degrees > -270:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
		
	if $Sprite.rotation_degrees < -360 or $Sprite.rotation_degrees > 360:
		$Sprite.rotation_degrees = 0
	
	if not Main.is_mobile:
		$Sprite.look_at(get_global_mouse_position())
	else:
		$Sprite.look_at(mobile_selected_pos.global_position)
	
# Puede recibir un PHWeapon o un null
func set_weapon(weapon):
	data = weapon
	
	if data:
		$Sprite.texture = load(data.texture_path)
	else:
		$Sprite.texture = null
	
	emit_signal("weapon_added", data)
	$Anim.play("show")
	set_physics_process(true)

func remove_weapon():
	$Anim.play("hide")
	
func _on_Anim_animation_finished(anim_name):
	if anim_name == "hide":
		data = null
		$Sprite.texture = null
		emit_signal("weapon_removed")
