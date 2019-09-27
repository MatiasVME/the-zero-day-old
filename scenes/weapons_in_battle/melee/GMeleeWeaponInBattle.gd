extends GWeaponInBattle

class_name GMeleeWeaponInBattle

var is_near = false

func attack(actor : GActor):
	if actor: actor.damage(self.weapon.damage)

func _on_IsNearAttackArea_body_entered(body):
	is_near = true

func _on_IsNearAttackArea_body_exited(body):
	is_near = false
