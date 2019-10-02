extends GMeleeWeaponInBattle

# Normalmente es un GActor pero puede ser null
func attack(actor = null):
	# Previene que haga el ataque rapidamente.
	if time_to_next_action_progress < time_to_next_action:
		return
	
	if actor: 
		look_at(actor.global_position)
	
	$Anim.play("Attack")
	
	.attack()

func _on_DamageArea_body_entered(body):
	if body is GActor:
		body.damage(self.weapon.damage)
