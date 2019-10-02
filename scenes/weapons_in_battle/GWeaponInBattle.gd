extends Node2D

class_name GWeaponInBattle

# Normalmente es un TZDWeapon pero a veces puede ser
# null
var weapon setget set_weapon, get_weapon

# GPlayer
var player

# Mobile
onready var game_camera = get_tree().get_nodes_in_group("GameCamera")

signal weapon_added(weapon)
signal weapon_removed()

func _ready():
	if Main.is_mobile and game_camera.size() > 0:
		game_camera = game_camera[0]

# Puede recibir un TZDWeapon o un null
func set_weapon(_weapon):
	weapon = _weapon
	
	if weapon:
		# TODO: Preferir preload en vez de load
		$Sprite.texture = load(weapon.texture_path)
	else:
		$Sprite.texture = null
	
	emit_signal("weapon_added", weapon)
	
func get_weapon():
	return weapon

func show_weapon():
	$Anim.play("show")

func hide_weapon():
	$Anim.play("hide")

func remove_weapon():
	$Anim.play("remove")
	
func _on_Anim_animation_finished(anim_name):
	if anim_name == "remove":
		weapon = null
		$Sprite.texture = null
		emit_signal("weapon_removed")
