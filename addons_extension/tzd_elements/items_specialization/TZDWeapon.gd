extends TZDItem

class_name TZDWeapon

# Tiempo para la proxima accion. Disparar en el caso de
# TZDDistanceWeapon y golpear en el caso de PHCloseRangeWeapon
var time_to_next_action = 0.5
var damage = 1.0

# Implementar en un futuro
var primary_element
var secondary_element
