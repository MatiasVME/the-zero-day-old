extends GDistanceWeaponInBattle

var reload_progress := 0.0
var need_reload := false
# Tiempo para la proxima accion de la arma
var time_to_next_action := 1.0
# Tiempo de espera entre cada bala
var time_to_next_action_progress := 0.0
# Total current ammo
var total_ammo = -1

signal reload

func _process(delta):
	# Equipamiento y reload
	#

	if self.weapon and time_to_next_action_progress < time_to_next_action:
		time_to_next_action_progress += delta
		return
	
	if self.weapon is TZDDistanceWeapon and self.weapon.current_shot == 0 and total_ammo != 0:
		if reload_progress > self.weapon.time_to_reload:
			if reload():
				SoundManager.play(SoundManager.Sound.RELOAD_1)
				reload_progress = 0.0
		else:
			reload_progress += delta

func set_weapon(weapon):
	time_to_next_action = weapon.time_to_next_action
	
	.set_weapon(weapon)

# Normalmente es un GActor pero puede ser null
func attack(actor = null):
	if self.weapon is TZDDistanceWeapon and player.can_fire and time_to_next_action_progress >= time_to_next_action and self.weapon.fire():
		if not Main.is_mobile:
			player.fire_dir = $Sprite.get_global_mouse_position() - global_position
			pass
		else:
			if player.selected_enemy:
				player.fire_dir = player.selected_enemy.global_position - global_position
			else:
				if player.current_move_dir != Vector2.ZERO:
					player.fire_dir = player.current_move_dir
				else:
					# Necesitamos que fire_dir sea igual a la dirección donde apunta gweaponinbattle
					player.fire_dir = $Sprite/Direction.global_position
			
		time_to_next_action_progress = 0.0
		fire()
		
# Esta funcion se llama mas de lo necesario - Necesita Revisión
# Retorna true si hace reload correctamente y
# false de lo contrario.
func reload():
	# Prevenir que se llame a esta funcion inecesariamente
	if not self.weapon is TZDDistanceWeapon or self.weapon.current_shot >= self.weapon.weapon_capacity:
		return false

	# Obtener las municiones
	var ammunition_inv = []
	total_ammo = 0

	for ammo in DataManager.get_current_inv().inv:
		if ammo is TZDAmmo and ammo.ammo_type == self.weapon.ammo_type:
			ammunition_inv.append(ammo)
			total_ammo += ammo.ammo_amount

	# Si no hay ammunition_inv entonces se sale de la
	# funcion
	if ammunition_inv.size() < 1:
		return false

	for ammo in ammunition_inv:
		if self.weapon.reload(ammo):
			break

#	for i in ammunition_inv.size() - 1:
#		if ammunition_inv[i].ammo_amount == 0:
#			ammunition_inv.pop_front()

	var i = 0
	while i < ammunition_inv.size():
		if ammunition_inv[i].ammo_amount == 0:
			ammunition_inv.pop_front()
		i += 1
		
	# Para que BulletInfo se actualize
	emit_signal("reload")

	return true
	
func fire():
	player.fire_dir = player.fire_dir.normalized()
	var bullet = ShootManager.fire(player.fire_dir, self.weapon.ammo_type, self.weapon.damage)
	bullet.global_position = $Sprite/ActionSpawn.global_position
	bullet.rotation = $Sprite.rotation
	player.get_parent().add_child(bullet)