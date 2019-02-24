extends PHWeapon

class_name PHDistanceWeapon

enum WeaponType {
	GUN,
	MACHINEGUN
}
var weapon_type = WeaponType.GUN

# Requiere municion?
var requires_ammo : bool = true
# Capacidad maxima de balas que puede contener el arma
var weapon_capacity = 6
# Disparo actual por ejemplo disparo 3 de 6, cuando llega a
# 0 se recarga.
var current_shot = 6
# Tiempo en segundos para recargar
var time_to_reload : int = 1
