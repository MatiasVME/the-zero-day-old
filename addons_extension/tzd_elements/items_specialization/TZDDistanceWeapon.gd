extends TZDWeapon

class_name TZDDistanceWeapon

# Esto sirve para que la interfaz (p.e: SecondaryWeapon)
# sepa que tipo de items es y se adecue su interfaz al
# tipo de item.
enum WeaponType {
	NORMAL_GUN,
	NORMAL_MACHINEGUN,
	PLASMA_GUN,
	PLASMA_MACHINEGUN,
	LASER,
	MISILE
}
var weapon_type = WeaponType.NORMAL_GUN

# Esta estructura tiene que ser una replica del
# AmmoType de TZDAmmo
enum AmmoType {
	NORMAL,
	PLASMA
}
var ammo_type = AmmoType.NORMAL

# Requiere municion?
var requires_ammo : bool = true
# Capacidad maxima de balas que puede contener el arma
var weapon_capacity = 6.0
# Disparo actual por ejemplo disparo 3 de 6, cuando llega a
# 0 se recarga.
var current_shot := 0
# Tiempo en segundos para recargar
var time_to_reload := 1.0

# Recarga dependiendo de la municion que reciba.
# devuelve true si se recarga completamente y
# false si no lo hace.
func reload(ammo : TZDAmmo) -> bool:
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

#func copy_properties(phdistweapon : TZDItem) -> void:
#	.copy_properties(phdistweapon)
#	ammo_type = phdistweapon.ammo_type
##	weapon_type = phdistweapon.weapon_type
#	requires_ammo = phdistweapon.requires_ammo
#	weapon_capacity = phdistweapon.weapon_capacity
#	current_shot = phdistweapon.current_shot
#	time_to_reload = phdistweapon.time_to_reload