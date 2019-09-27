extends TZDWeapon

class_name TZDMeleeWeapon

# Esto sirve para que la interfaz (p.e: PrimaryWeapon)
# sepa que tipo de items es y se adecue su interfaz al
# tipo de item.
enum WeaponType {
	IRON_SWORD,
	DIAMOND_SWORD,
	EMERALD_SWORD,
	RUBY_SWORD
}
var weapon_type : int = WeaponType.IRON_SWORD

var distance = 40