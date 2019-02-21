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

enum AmmoType {
	NORMAL,
	PLASMA
}
var ammo_type = AmmoType.NORMAL
