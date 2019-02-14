extends PHEquipment

class_name PHWeapon

# Tiempo para la proxima accion. Disparar en el caso de
# PHDistanceWeapon y golpear en el caso de PHCloseRangeWeapon
var time_to_next_action : int = 0.5
var damage : int = 1