extends Node2D

onready var hud = get_parent()

# Item equipado (a veces es null)
var current_equip setget set_current_equip, get_current_equip

var is_showing := false

#signal bullet_info_updated()

func _ready():
	PlayerManager.connect("player_changed", self, "_on_player_changed")
	PlayerManager.connect("player_shooting", self, "_on_player_shooting")
	PlayerManager.connect("player_reload", self, "_on_player_reload")

	hud.get_node("PlayerMenu/Panels/Inventory").connect("item_removed", self, "_on_item_removed")
	
	update_bullet_info(null)
	
func update_bullet_info(equip):
	# Si esta equipado y no se muestra
	if equip and not is_showing:
		$Anim.play("show")
		is_showing = true
	# Si no esta equipado y se esta mostrando
	elif not equip and is_showing:
		$Anim.play_backwards("show")
		is_showing = false
		return
	# No este equipado
	elif not equip:
#		print("No este equipado")
		return
	
	if equip is TZDDistanceWeapon:
		if equip.requires_ammo:
			$Bullet/CurrentAndMax.text = str(equip.current_shot) + "/" + str(equip.weapon_capacity)
			$Total/Total.text = str(hud.inventory.get_total_ammo())
		else:
			$Bullet/CurrentAndMax.text = "-/-"
	else:
		if is_showing:
			$Anim.play_backwards("show")
			is_showing = false

func update_images_bullet_info(equip):
	if equip is TZDMeleeWeapon:
		$Bullet/BulletImg.texture = null
	elif equip is TZDDistanceWeapon:
		$Bullet/BulletImg.texture = ShootManager.get_bullet_img(equip.ammo_type)
		var hola = $Bullet/BulletImg.texture 
		$Total/TotalImg.texture = ShootManager.get_bullet_box_img(equip.ammo_type)
	
# Normalmente recibe un TZDWeapon pero puede recibir null
func set_current_equip(equip):
#	print("update_bullet_info(equip) (equip): ", (equip is TZDWeapon))
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
	
