extends GWeaponInBattle

class_name GDistanceWeaponInBattle

signal anim_finished(anim)

func hide_temp_weapon():
	$Anim.play("temp_hide")
	
func _process(delta):
#	if not self.weapon:
#		set_process(false)
#		print_debug(self, " no esta asociado a un weapon: ", weapon)
#		return

	if $Sprite.rotation_degrees > 90 and $Sprite.rotation_degrees < 270 or $Sprite.rotation_degrees < -90 and $Sprite.rotation_degrees > -270:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false

	if $Sprite.rotation_degrees < -360 or $Sprite.rotation_degrees > 360:
		$Sprite.rotation_degrees = 0

	if not Main.is_mobile:
		$Sprite.look_at(get_global_mouse_position())
	else:
		# Apunta al enemigo
		if is_instance_valid(player.selected_enemy):
			$Sprite.look_at(player.selected_enemy.global_position)
#			print("---1---")
		# Cuando se mueve con el arma
		elif game_camera.global_position != $Sprite.global_position:
			$Sprite.rotation_degrees = 0
			$Sprite.look_at(game_camera.global_position)
			$Sprite.rotation_degrees += 180
#			print("---2---")
		# Cuando esta quieto con el arma
		else:
			$Sprite.look_at(game_camera.global_position)
#			print("---3---")

func _on_Anim_animation_finished(anim_name):
	emit_signal("anim_finished", anim_name)
