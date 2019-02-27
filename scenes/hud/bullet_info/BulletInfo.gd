extends Node2D

# Item equipado (a veces es null)
var current_equip setget set_current_equip, get_current_equip
# Total de balas disponibles para la arma equipada
var total_ammo : int = 0 setget , get_total_ammo

func _ready():
	PlayerManager.connect("player_changed", self, "_on_player_changed")
	PlayerManager.connect("player_shooting", self, "_on_player_shooting")
#	reload()
	
func update_bullet_info():
	if current_equip:
		show()
	else:
		hide()
	
	if current_equip is PHWeapon:
		if current_equip.requires_ammo:
			$Bullet/CurrentAndMax.text = str(current_equip.current_shot) + "/" + str(current_equip.weapon_capacity)
			$Total/Total.text = str(get_total_ammo())
		else:
			$Bullet/CurrentAndMax.text = "-/-"
	else:
		hide()
	
# Normalmente recibe un PHItem pero puede recibir null
func set_current_equip(equip):
	current_equip = equip
	update_bullet_info()

# Devuelve el total de municion que puede ocupar,
# dependiendo de las municiones -para la arma actual- 
# que que hay en el inventario
func get_total_ammo():
	var inv = DataManager.get_current_inv().inv
	total_ammo = 0
	
	for item in inv:
		if item is PHAmmo and current_equip.ammo_type == item.ammo_type:
			total_ammo += item.ammo_amount
	
	return total_ammo

func get_current_equip():
	return current_equip

func _on_player_changed(new_player):
	update_bullet_info()

func _on_player_shooting(player, direction):
	update_bullet_info()
	