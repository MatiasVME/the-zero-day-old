"""
	TODO: Debería ser una escena herdada y heredar de
	GMeleeWeapon, pero por mientras esta así.
"""

extends Node2D

# Normalmente es un TZDWeapon pero a veces puede ser
# null
var data

onready var player : GPlayer setget set_player

var is_near = false

var time_to_next_action := 0.4
var time_to_next_action_progress := 0.0

# WeaponSprite RotationDegrees
var ws_rd = 0

var img_boxing1 = preload("res://scenes/weapons_in_battle/melee/boxing_attack/Images/boxing.png")

signal weapon_added(weapon)
signal weapon_removed()

func _process(delta):
	if time_to_next_action_progress <= time_to_next_action:
		time_to_next_action_progress += delta
	
	ws_rd = rotation_degrees
	
	if ws_rd > 90 and ws_rd < 270 or ws_rd < -90 and ws_rd > -270:
		$WeaponSprite.flip_v = true
	else:
		$WeaponSprite.flip_v = false
		
	if ws_rd < -360 or ws_rd > 360:
		rotation_degrees = 0
	
	if not Main.is_mobile:
		$Weapon.look_at(get_global_mouse_position())
	elif player and player.mobile_selected_pos and player.selected_enemy:
		look_at(player.selected_enemy.global_position)
	else:
		# TODO: Apuntar a la ultima dirección de movimiento (a donde
		# miro por última vez)
		pass

func attack():
	if time_to_next_action_progress >= time_to_next_action:
		$Anim.play("box_hit")
		SoundManager.play(SoundManager.Sound.HIT_1)
		time_to_next_action_progress = 0.0
	
# Puede recibir un PHMeleeWeapon o un null
func set_weapon(weapon = null):
	data = weapon
	
	if not weapon:
		$WeaponSprite.texture = img_boxing1
	
	emit_signal("weapon_added", weapon)

func remove_weapon():
	data = null
	$WeaponSprite.texture = img_boxing1
	emit_signal("weapon_removed")

func set_player(_player):
	player = _player

func _on_HitArea_body_entered(body):
	if body is GEnemy or body is GStructure:
		body.damage(PlayerManager.current_player.data.attack)
	elif body is GBullet:
		body.direction = body.direction.bounce(get_parent().global_position.normalized())

func _on_IsNearAttackArea_body_entered(body):
	is_near = true

func _on_IsNearAttackArea_body_exited(body):
	is_near = false
