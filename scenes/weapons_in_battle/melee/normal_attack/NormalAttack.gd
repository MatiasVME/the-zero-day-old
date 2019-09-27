extends GMeleeWeaponInBattle

func attack(actor):
	if actor: 
		look_at(actor.global_position)
	
	$Anim.play("Attack")
	
	if actor:
		actor.damage(self.weapon.damage)