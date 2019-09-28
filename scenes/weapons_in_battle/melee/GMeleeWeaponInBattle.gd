extends GWeaponInBattle

class_name GMeleeWeaponInBattle

var is_near = false

func _on_IsNearAttackArea_body_entered(body):
	is_near = true

func _on_IsNearAttackArea_body_exited(body):
	is_near = false
