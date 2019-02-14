extends PHWeapon

class_name PHDistanceWeapon

enum WeaponType {
	GUN,
	MACHINEGUN
}
var weapon_type = WeaponType.GUN

# Requiere municion?
var requires_ammo : bool = true
# Capacidad de municion que tiene el arma
# -1 Indica que no necesita ser recargada
var ammo_capacity : int = -1
# Tiempo en segundos para recargar
var time_to_reload : int = 1
