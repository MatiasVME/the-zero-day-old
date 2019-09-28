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
#	elif not self.weapon and melee_time_to_next_action_progress < melee_time_to_next_action:
#		melee_time_to_next_action_progress += delta
#		return

	if self.weapon is TZDDistanceWeapon and self.weapon.current_shot == 0 and total_ammo != 0:
		if reload_progress > self.weapon.time_to_reload:
			if reload():
				SoundManager.play(SoundManager.Sound.RELOAD_1)
				reload_progress = 0.0
		else:
			reload_progress += delta

# Normalmente es un GActor pero puede ser null
func attack(actor = null):
	pass

func update_weapon():
	total_ammo = -1
	
	if self.weapon is TZDDistanceWeapon:
		$GWeaponInBattle.set_weapon(self.weapon)
#		can_fire = true
		time_to_next_action = self.weapon.time_to_next_action
	else:
		$GWeaponInBattle.set_weapon(null)
#		can_fire = false
		
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

	for i in ammunition_inv.size() - 1:
		if ammunition_inv[i].ammo_amount == 0:
			ammunition_inv.pop_front()

	# Para que BulletInfo se actualize
	emit_signal("reload")

	return true