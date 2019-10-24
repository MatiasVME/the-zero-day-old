extends GMeleeWeaponInBattle

# Normalmente es un GActor pero puede ser null
func attack(actor = null):
	# Previene que haga el ataque rapidamente.
	if time_to_next_action_progress < time_to_next_action:
		return
	
	if is_instance_valid(actor): 
		look_at(actor.global_position)
		
	$Sprite.self_modulate = Color(1,1,1,1)
	
	$Tween.interpolate_property(
		$Sprite,
		"scale",
		Vector2.ZERO,
		Vector2(1.2, 1.2),
		0.1,
		Tween.EASE_IN,
		Tween.TRANS_LINEAR
	)
	
	if not $Sprite.flip_v:
		$Tween.interpolate_property(
			$Sprite,
			"rotation_degrees",
			-90,
			90,
			0.3,
			Tween.EASE_IN,
			Tween.TRANS_LINEAR
		)
	else:
		$Tween.interpolate_property(
			$Sprite,
			"rotation_degrees",
			90,
			-90,
			0.3,
			Tween.EASE_IN,
			Tween.TRANS_LINEAR
		)
	
	$Tween.interpolate_property(
		$Sprite,
		"self_modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		0.05,
		Tween.EASE_IN,
		Tween.TRANS_LINEAR,
		0.25
	)
	$Tween.start()
	
	.attack()

func _on_DamageArea_body_entered(body):
	if body is GEnemy or body is GStructure:
		body.damage(self.weapon.damage)
