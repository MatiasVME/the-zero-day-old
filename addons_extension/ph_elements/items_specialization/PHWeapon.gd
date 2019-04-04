extends PHEquipment

class_name PHWeapon

# Tiempo para la proxima accion. Disparar en el caso de
# PHDistanceWeapon y golpear en el caso de PHCloseRangeWeapon
var time_to_next_action = 0.5
var damage = 1.0

func copy_properties(phweapon : PHItem) -> void:
	.copy_properties(phweapon)
	time_to_next_action = phweapon.time_to_next_action
	damage = phweapon.damage