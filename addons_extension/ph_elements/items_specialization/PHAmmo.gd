"""
PHAmmo.gd

Se utiliza para municiones.
"""

extends PHItem

class_name PHAmmo

# ammo_amount indica el numero de balas en la caja,
# en cambio amount indica el numero de cajas que hay.
# Una caja ocupa un slot, en cambio un ammo_amoun depende
# de una caja.
var ammo_amount = 1

# Esta estructura tiene que ser una replica del
# AmmoType de PHDistanceWapon
enum AmmoType {
	NORMAL,
	PLASMA
}
var ammo_type = 0

func copy_properties(phammo : PHItem) -> void:
	.copy_properties(phammo)
	ammo_amount = phammo.ammo_amount
	ammo_type = phammo.ammo_type
