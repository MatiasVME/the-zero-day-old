extends Node2D

onready var hud = get_parent()

# Item equipado (a veces es null)
var current_equip setget set_current_equip, get_current_equip
# Total de balas disponibles para la arma equipada

func _ready():
	PlayerManager.connect("player_changed", self, "_on_player_changed")
	PlayerManager.connect("player_shooting", self, "_on_player_shooting")
	PlayerManager.connect("player_reload", self, "_on_player_reload")
	
	hud.get_node("Inventory").connect("item_removed", self, "_on_item_removed")
	
	
func update_bullet_info():
	if current_equip:
		show()
	else:
		hide()
	
	if current_equip is PHWeapon:
		if current_equip.requires_ammo:
			$Bullet/CurrentAndMax.text = str(current_equip.current_shot) + "/" + str(current_equip.weapon_capacity)
			$Total/Total.text = str(hud.get_node("Inventory").get_total_ammo())
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

func _on_player_changed(new_player):
	update_bullet_info()

func _on_player_shooting(player, direction):
	update_bullet_info()

func _on_player_reload():
	update_bullet_info()

func _on_item_removed(row_num, slot_num):
	update_bullet_info()