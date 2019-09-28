extends GMeleeWeaponInBattle

# Normalmente es un GActor pero puede ser null
func attack(actor = null):
	if actor: 
		look_at(actor.global_position)
	
	$Anim.play("Attack")

func _on_DamageArea_body_entered(body):
	if body is GActor:
		body.damage(self.weapon.damage)
