extends TZDWeapon

class_name TZDMeleeWeapon

# Esto sirve para que la interfaz (p.e: PrimaryWeapon)
# sepa que tipo de items es y se adecue su interfaz al
# tipo de item.
enum WeaponType {
	NORMAL_SWORD,
	PLASMA_SWORD
}
var weapon_type = WeaponType.NORMAL_SWORD

# Posibles vars
# distance
# angle