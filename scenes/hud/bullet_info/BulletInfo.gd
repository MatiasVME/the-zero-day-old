extends Node2D

# Item equipado (a veces es null)
var current_equip setget set_current_equip, get_current_equip
# Total de balas disponibles para la arma equipada
var current_total_ammo

func update_bullet_info():
	if current_equip:
		show()
	else:
		hide()
	
	if current_equip is PHWeapon:
		if current_equip.requires_ammo:
			$Bullet/CurrentAndMax.text = str(current_equip.current_shot) + "/" + str(current_equip.weapon_capacity)
		else:
			$Bullet/CurrentAndMax.text = "-/-"
	else:
		hide()
			
# Normalmente recibe un PHItem pero puede recibir null
func set_current_equip(equip):
	current_equip = equip
	update_bullet_info()
	
func get_current_equip():
	return current_equip
	
