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
	
	update_bullet_info(null)
	
func update_bullet_info(equip):
	if equip:
		show()
	else:
		hide()
		return
	
	if equip is PHWeapon:
		if equip.requires_ammo:
			$Bullet/CurrentAndMax.text = str(equip.current_shot) + "/" + str(equip.weapon_capacity)
			$Total/Total.text = str(hud.get_node("Inventory").get_total_ammo())
		else:
			$Bullet/CurrentAndMax.text = "-/-"
	else:
		hide()

func update_images_bullet_info(equip):
	if equip:
		$Bullet/BulletImg.texture = load(ShootManager.get_bullet_img(equip.ammo_type))
		$Total/TotalImg.texture = load(ShootManager.get_bullet_box_img(equip.ammo_type))
	
# Normalmente recibe un PHWeapon pero puede recibir null
func set_current_equip(equip):
	update_bullet_info(equip)
	update_images_bullet_info(equip)

func get_current_equip():
	return current_equip

func _on_player_changed(new_player):
	update_bullet_info(new_player.data.equip)
	update_images_bullet_info(new_player.data.equip)

func _on_player_shooting(player, direction):
	update_bullet_info(player.data.equip)
	update_images_bullet_info(player.data.equip)

func _on_player_reload(player):
	update_bullet_info(player.data.equip)

func _on_item_removed(row_num, slot_num):
	update_bullet_info(null)
	update_images_bullet_info(null)
	