extends PHWeapon

class_name PHDistanceWeapon

enum WeaponType {
	GUN,
	MACHINEGUN
}
var weapon_type = WeaponType.GUN

# Esta estructura tiene que ser una replica del
# AmmoType de PHAmmo
enum AmmoType {
	NORMAL,
	PLASMA
}
var ammo_type = AmmoType.NORMAL

# Requiere municion?
var requires_ammo : bool = true
# Capacidad maxima de balas que puede contener el arma
var weapon_capacity = 6
# Disparo actual por ejemplo disparo 3 de 6, cuando llega a
# 0 se recarga.
var current_shot := 0
# Tiempo en segundos para recargar
var time_to_reload := 1
# Tiempo entre cada bala
# Usar time_to_next_action

# Recarga dependiendo de la municion que reciba.
# devuelve true si se recarga completamente y
# false si no lo hace.
func reload(ammo : PHAmmo) -> bool:
	# Validar si puede hacer el reload
	# 1) Tiene que haber municion disponible
	# 2) No tiene que estar ya recargada
	if ammo.ammo_amount < 1:
		return false
	if is_recharged():
		return true
	
	for i in weapon_capacity - current_shot:
		if is_recharged():
			return true
		# No queda municion disponible
		if ammo.ammo_amount < 1:
			return false
		
		current_shot += 1
		ammo.ammo_amount -= 1
	
	# Nunca llega a esto (segun yo)
	return false

func fire() -> bool:
	# Validar:
	# 1) No tiene un arma equipada?
	# 2) Tiene balas disponibles para usar?
	if current_shot < 1:
		return false
	
	# De lo contrario...
	current_shot -= 1
	return true

func is_recharged():
	return weapon_capacity == current_shot



