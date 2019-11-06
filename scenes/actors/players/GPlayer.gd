extends GActor

class_name GPlayer

# Es la data del player y la logica del mismo
var data : TZDPlayer # Este es el que equipa el arma

export (int) var speed = 3000

var move = Vector2.ZERO

var can_fire := false

# Escena para mostrar el daño en forma numérica
var damage_label = preload("res://scenes/hud/floating_hud/FloatingText.tscn")

# Último en dañar al GPlayer
var last_to_damage = null

var fire_dir := Vector2.ZERO
var current_move_dir := Vector2.ZERO

var button_dash_is_pressed := false
# Se esta haciendo Dash ?
var doing_dash := false
var dash_dir := Vector2.ZERO

enum DashState {START, DOING, END}
var dash_state = DashState.START

# Dash especial
#

enum SpecialDashState {UNSTATE, START, DOING, END}
var special_dash_state = SpecialDashState.START

var is_special_dash := false
var doing_special_dash := false
# Tiempo total acumulado para hacer el dash especial
var special_dash_time_accum := 0.0
var max_special_dash_time_accum := 5.0

var ot_scale_head_doing_dash := false

# Hud
#

var hud

# Mobile
#

# GActors seleccionados
var selectables := []
# Indice del GActor actual
var selected_num := -1 # -1 es nignuno seleccionado
# GActor seleccionado
var selected_enemy
# Cuando el botón de acción esta presionado (fire, interact)
var action_pressed := false

# Se debe establecer la camara cuando se usa un player
var game_camera : GameCamera setget set_game_camera

# Obsoleto (NEEDFIX) -->
onready var mobile_selected_pos = get_tree().get_nodes_in_group("GameCamera")

# Contiene/contendra el nodo BoxingAttack
var boxing_attack

var gui_primary_weapon : GMeleeWeaponInBattle
# Es el arma secundaria actual
var gui_secondary_weapon : GDistanceWeaponInBattle
# Es el arma secundaria anterior
var old_gui_secondary_weapon : GDistanceWeaponInBattle

signal fire(dir)
signal dead
signal spawn
signal reload
signal item_taken(item)

func _ready():
	self.actor_owner = Enums.ActorOwner.PLAYER
	
	connect("fire", self, "_on_fire")
	
	if is_instance_valid(data):
		data.connect("dead", self, "_on_dead")
		data.connect("remove_hp", self, "_on_remove_hp")
		data.connect("primary_weapon_equiped", self, "_on_primary_weapon_equiped") # Cambiar en un futuro probablemente
		
		data.restore_hp()
	
		if not data.primary_weapon:
			config_boxing_attack()
		else:
			config_primary_weapon()
	
func _move_handler(delta, distance, run):
	var dir := Vector2()
	
	if not Main.is_mobile:
		dir.x = sign(distance.x)
		dir.y = sign(distance.y)
	else:
		dir = distance.normalized()
	
	# Si esta haciendo dash
	if doing_dash and not is_special_dash:
		do_dash_if_can(delta)
	elif is_special_dash or doing_special_dash:
		return
	else:
		# Previene el movimiento cuando esta haciendo un dash especial
		if button_dash_is_pressed:
			return
			
		move = dir * speed * 2 * delta
		
	if not doing_dash: $Sprites/AnimMove.play("Run")
	
	if dir.y > 0.49:
		if dir.x > 0 : flip_h_sprites(false)
		elif dir.x < 0 : flip_h_sprites(true)
	elif dir.y < -0.49:
		if dir.x > 0 : flip_h_sprites(false)
		elif dir.x < 0 : flip_h_sprites(true)
	else:
		if dir.x > 0 : flip_h_sprites(false)
		elif dir.x < 0 : flip_h_sprites(true)
		
	if move != Vector2.ZERO:
		move.x /= 1.5
		move.y /= 1.5
		
	move_and_slide(move, Vector2())

# Hacer dash si puede
func do_dash_if_can(delta):
	move = dash_dir * speed * 8 * delta
	
	match dash_state:
		DashState.START:
			# Si se esta ejecutando la animación start
			if $Sprites/AnimDash.is_playing() and $Sprites/AnimDash.current_animation != "DashStart":
				return
			else:
				dash_state = DashState.DOING

		DashState.DOING:
			use_stamina(delta)
			# Si el tween DoingDash no se esta ejecutando
			if not $Sprites/DoingDash.is_active():
				# Cambiamos las collision layer y mask antes de hacer el tween
				collision_layer = 4
				collision_mask = 4

				if not $Sprites/Head.flip_h:
					$Sprites/DoingDash.interpolate_property(
						$Sprites,
						"rotation_degrees",
						0, 
						360,
						0.3,
						Tween.TRANS_LINEAR,
						Tween.EASE_OUT
					)
				else:
					$Sprites/DoingDash.interpolate_property(
						$Sprites,
						"rotation_degrees",
						0, 
						-360,
						0.3,
						Tween.TRANS_LINEAR,
						Tween.EASE_OUT
					)
				
				$Sprites/DoingDash.start()
		DashState.END:
			doing_dash = false
	
func do_special_dash_if_can(delta):
	# Definir si es un dash especial o no
	if doing_dash and current_move_dir == Vector2.ZERO:
		special_dash_state = SpecialDashState.START
	
	match special_dash_state:
		SpecialDashState.UNSTATE:
			return
		SpecialDashState.START: 
			# Si la dirección sigue siendo ZERO
			if current_move_dir == Vector2.ZERO:
				if max_special_dash_time_accum >= special_dash_time_accum:
					special_dash_time_accum += delta
					
					if $Sprites/Head.flip_h:
						$Sprites/Head.rotation_degrees -= clamp(delta * 250 * special_dash_time_accum, 10, 20)
					else:
						$Sprites/Head.rotation_degrees += clamp(delta * 250 * special_dash_time_accum, 10, 20)
					
					use_stamina(delta, 0.5)
				else:
					if $Sprites/Head.flip_h:
						$Sprites/Head.rotation_degrees -= clamp(250 * delta * special_dash_time_accum, 10, 20)
					else:
						$Sprites/Head.rotation_degrees += clamp(250 * delta * special_dash_time_accum, 10, 20)
				
				is_special_dash = true
				special_dash_state = SpecialDashState.DOING
				
				if not ot_scale_head_doing_dash:
					ot_scale_head_doing_dash = true
					
					$Sprites/SpecialDash.interpolate_property(
						$Sprites/Head,
						"scale",
						Vector2(1, 1),
						Vector2(2, 2),
						0.5,
						Tween.TRANS_LINEAR,
						Tween.EASE_OUT
					)
					$Sprites/SpecialDash.start()
			return
		SpecialDashState.DOING:
			ot_scale_head_doing_dash = false
			doing_special_dash = true
			
			# Cambiamos las collision layer y mask antes de hacer el
			# dash especial
			collision_layer = 4
			collision_mask = 4
			
			move_and_slide(current_move_dir.normalized() * 4500 * delta * special_dash_time_accum)
			$Sprites/Head.rotation_degrees += 40
			
			if special_dash_time_accum <= 0:
				special_dash_state = SpecialDashState.END
			else:
				special_dash_time_accum -= delta * 8
				return
		SpecialDashState.END: 
			is_special_dash = false
			doing_dash = false
			doing_special_dash = false
			$Sprites/Head.rotation_degrees = 0
			special_dash_state = SpecialDashState.UNSTATE
			
			collision_layer = 3
			collision_mask = 3
			
			$Sprites/SpecialDash.stop($Sprites/Head)
			$Sprites/SpecialDash.interpolate_property(
				$Sprites/Head,
				"scale",
				Vector2(2, 2),
				Vector2(1, 1),
				0.05,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT
			)
			$Sprites/SpecialDash.start()
	
# Subir stamina
func go_up_stamina(delta):
	if data.stamina < data.stamina_max:
		data.stamina = data.stamina + delta * 16

func use_stamina(delta, stamina_multiplier = 1):
	if data.stamina > 1.0:
		data.stamina -= delta * 32 * stamina_multiplier
	else:
		dash_state = DashState.END
		return

func _stop_handler(delta):
	if doing_dash: return
	
	if $Sprites/AnimMove.current_animation != "Idle" and $Sprites/AnimHit.current_animation != "Hit" or not $Sprites/AnimMove.is_playing():
		$Sprites/AnimMove.play("Idle")
	
func _fire_handler():
	if selected_enemy:
		# Si tiene primary weapon y esta cerca
		if gui_primary_weapon and gui_primary_weapon.is_near:
			melee_attack()
		# Si no hay arma primaria y el enemigo esta cerca
		elif not data.primary_weapon and global_position.distance_to(selected_enemy.global_position) < 26:
			melee_attack()
		else:
			distance_attack()
	else:
		if gui_secondary_weapon:
			distance_attack()
		else:
			# Melee attack verifica que tipo de ataque melee hace
			# y hace el ataque.
			melee_attack()
	
func _physics_process(delta):
	if not can_move or is_disabled:
		return
	
	# Dash
	#
	
	if is_special_dash:
		do_special_dash_if_can(delta)
		
	if not doing_dash:
		go_up_stamina(delta)
	else:
		do_special_dash_if_can(delta)
		
	# Action (fire, interact)
	#
	
	if action_pressed:
		_fire_handler()

func disable_player(_visible := false):
	is_disabled = true
	
	disable_interact(_visible)
	
func enable_player(_can_fire := false):
	is_disabled = false
	enable_interact(_can_fire)
	
func disable_interact(_visible := false):
	visible = _visible
	can_move = false
	can_fire = false
	$Collision.disabled = true
	
	if gui_primary_weapon: 
		gui_primary_weapon.hide()
	
	if gui_secondary_weapon:
		gui_secondary_weapon.hide()
	
func enable_interact(_can_fire := false):
	visible = true
	can_move = true
	can_fire = _can_fire
	$Collision.disabled = false
	
# Hace el ataque melee y configura si no hay arma configurada
func melee_attack():
	if data.primary_weapon and data.primary_weapon is TZDMeleeWeapon:
		if not gui_primary_weapon: config_primary_weapon()
		
		if gui_primary_weapon.is_near:
			gui_primary_weapon.attack(selected_enemy)
		else:
			gui_primary_weapon.attack()
	else:
		boxing_attack.attack()
		
	if is_instance_valid(gui_secondary_weapon):
		gui_secondary_weapon.hide_temp_weapon()

func distance_attack():
	if not is_instance_valid(gui_secondary_weapon):
		return
	
	gui_secondary_weapon.attack(selected_enemy)
	hud.get_node("BulletInfo").update_bullet_info(data.secondary_weapon)

func config_boxing_attack():
	boxing_attack = Factory.EquipmentFactory.get_boxing_attack()
	var current_primary_weapon = $CurrentWeapon/PrimaryWeapon.get_child(0)
		
	if current_primary_weapon and current_primary_weapon != boxing_attack:
		$CurrentWeapon/PrimaryWeapon.remove_child(current_primary_weapon)
		
	$CurrentWeapon/PrimaryWeapon.add_child(boxing_attack)
	boxing_attack.player = self

func config_primary_weapon():
	if not data.primary_weapon:
		print_debug("No encuentra arma primaria: ", data.primary_weapon)
		return
	
	if $CurrentWeapon/PrimaryWeapon.get_child_count() > 0 and $CurrentWeapon/PrimaryWeapon.get_children()[0] == boxing_attack:
		$CurrentWeapon/PrimaryWeapon.remove_child(boxing_attack)
	
	gui_primary_weapon = Factory.EquipmentFactory.get_primary_weapon(data.primary_weapon)
	
	if gui_primary_weapon:
		$CurrentWeapon/PrimaryWeapon.add_child(gui_primary_weapon)
	
# Player tiene acceso al hud y lo configura
func set_hud(_hud):
	hud = _hud
	
	# Configurar HUD
	hud.get_node("Analog").connect("current_force_updated", self, "_on_current_force_updated")
	hud.connect("hud_item_hotbar_selected", self, "_on_hud_item_hotbar_selected")
	hud.connect("hud_action", self, "_on_hud_action_button")

func set_game_camera(_game_camera):
	game_camera = _game_camera
	
	mobile_selected_pos = game_camera.get_node("MobileSelected/Pos")

# Mobile selecciona el próximo actor
func select_next():
	if selectables.size() > 1:
		if (selected_num + 1) % selectables.size() == 0 or selected_num >= selectables.size():
			selected_num = 0
		else:
			selected_num += 1
		selected_enemy = selectables[selected_num]
	elif selectables.size() == 1:
		selected_num = 0
		selected_enemy = selectables[selected_num]
	else:
		selected_num = -1

func flip_h_sprites(value):
	$Sprites/LegLeft.flip_h = value
	$Sprites/LegRight.flip_h = value
	$Sprites/Body.flip_h = value
	$Sprites/Head.flip_h = value

# who: es quien le hizo daño
func damage(amount, who : RPGCharacter):
	data.damage(amount, who)
	last_to_damage = who

func dash_start():
	doing_dash = true
	dash_dir = current_move_dir.normalized() / 4 * 3
	dash_state = DashState.START
	button_dash_is_pressed = true
	
	$Sprites/AnimMove.stop()
	$Sprites/AnimDash.play("DashStart")
	
	if gui_secondary_weapon:
		gui_secondary_weapon.hide_weapon()
	
	if gui_primary_weapon:
		gui_primary_weapon.get_node("Sprite/DamageArea/Collision").disabled = true
	
func dash_stop():
	doing_dash = false
	
	dash_dir = Vector2.ZERO
	button_dash_is_pressed = false
	
	collision_layer = 3
	collision_mask = 3
	
	$Sprites/AnimDash.play("DashStop")
	$Sprites/Head.rotation_degrees = 0
	
	if gui_secondary_weapon:
		gui_secondary_weapon.show_weapon()
		
	if gui_primary_weapon:
		gui_primary_weapon.get_node("Sprite/DamageArea/Collision").disabled = false

func equip_primary_weapon(melee_item : TZDMeleeWeapon):
	data.primary_weapon = melee_item

func equip_secondary_weapon(weapon : TZDDistanceWeapon):
	data.secondary_weapon = weapon
	can_fire = true
#	gui_secondary_weapon.reload()

	old_gui_secondary_weapon = gui_secondary_weapon
	gui_secondary_weapon = Factory.EquipmentFactory.get_secondary_weapon(data.secondary_weapon)
	gui_secondary_weapon.player = self

	# Para que el nuevo gui_secondary_weapon toma la rotación del sprite de old_gui_secondary_weapon
	if is_instance_valid(old_gui_secondary_weapon) and is_instance_valid(gui_secondary_weapon):
		gui_secondary_weapon.get_node("Sprite").rotation_degrees = old_gui_secondary_weapon.get_node("Sprite").rotation_degrees

	$CurrentWeapon/SecondaryWeapon.add_child(gui_secondary_weapon)
	gui_secondary_weapon.show_weapon()

	hud.get_node("BulletInfo").set_current_equip(data.secondary_weapon)

	gui_secondary_weapon.connect("reload", self, "_on_secondary_weapon_reload")
	
	if is_instance_valid(old_gui_secondary_weapon) and old_gui_secondary_weapon != gui_secondary_weapon:
		unequip_secondary_weapon(old_gui_secondary_weapon)

func unequip_secondary_weapon(_gui_secondary_weapon = null):
	if is_instance_valid(_gui_secondary_weapon):
		_gui_secondary_weapon.connect("anim_finished", self, "_on_gui_secondary_weapon_anim_finished", [_gui_secondary_weapon])
		_gui_secondary_weapon.remove_weapon()
	elif is_instance_valid(gui_secondary_weapon):
		gui_secondary_weapon.connect("anim_finished", self, "_on_gui_secondary_weapon_anim_finished", [gui_secondary_weapon])
		gui_secondary_weapon.remove_weapon()
		
# Cuando el botón de action del hud es pressionado y soltado
func _on_hud_action_button(is_pressed):
	action_pressed = is_pressed

## Cuando alguna animación de gui_secondary_weapon esta finalizada
func _on_gui_secondary_weapon_anim_finished(anim_name, _gui_secondary_weapon):
	if anim_name == "remove":
		$CurrentWeapon/SecondaryWeapon.remove_child(_gui_secondary_weapon)
#		data.secondary_weapon = null
		_gui_secondary_weapon.queue_free()
		#can_fire = false

func _on_dead():
	is_mark_to_dead = true
	disable_player(true)
	$Sprites/AnimDead.play("Dead")
	SoundManager.play(SoundManager.Sound.PLAYER_DEAD_1)
	
	game_camera.following = last_to_damage
	
#	Main.lose_adventure()

func _on_remove_hp(amount):
	if is_inmortal: return

	$Sprites/AnimHit.play("Hit")
	
	# Instancia un label indicando el daño recibido y lo agrega al árbol
	var dmg_label : FloatingText = damage_label.instance()
	dmg_label.init("-" + str(amount), FloatingText.Type.DAMAGE)
	dmg_label.position = global_position
	get_parent().add_child(dmg_label)

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Dead":
		visible = false

func _on_InteractArea_body_entered(body):
	if body is ItemInWorld:
		if DataManager.inventories.size() > 0:
			body.take_item(DataManager.inventories[DataManager.current_player])
			emit_signal("item_taken", body.data)
	elif body is GBullet and not is_inmortal:
		if body.bullet_owner != self:
			data.damage(body.damage, body.bullet_owner.data)
			body.dead()
	elif body is GBullet and is_inmortal:
		body.dead()
	elif body is GEnemy and doing_special_dash:
		body.damage(data.special_dash_damage, self.data)

func _on_DetectArea_body_entered(body):
	if body is GActor:
		if body == self or body is GEnviroment:
			return
		
		selectables.append(body)
		
		if selectables.size() == 1:
			select_next()
	
func _on_DetectArea_body_exited(body):
	if body is GActor:
		if body == self or body is GEnviroment:
			return
		
		if selectables.has(body) or body.has_meta("structure_owner"):
			var enemy_exited_num = selectables.find(body)
			selectables.remove(enemy_exited_num)
			
			if selected_num == enemy_exited_num:
				select_next()
			
			if selectables.size() == 0:
				selected_enemy = null

func _on_primary_weapon_equiped(weapon : TZDMeleeWeapon):
	gui_primary_weapon = Factory.EquipmentFactory.get_primary_weapon(weapon)
	if boxing_attack: $CurrentWeapon/PrimaryWeapon.remove_child(boxing_attack)
	gui_primary_weapon.player = self
	$CurrentWeapon/PrimaryWeapon.add_child(gui_primary_weapon)

func _on_secondary_weapon_reload():
	hud.get_node("BulletInfo").update_bullet_info(data.secondary_weapon)

# Slot data puede ser un TZDItem o null
func _on_hud_item_hotbar_selected(slot_data):
	if slot_data is TZDDistanceWeapon:
		equip_secondary_weapon(slot_data)
		return
	elif not gui_primary_weapon and slot_data is TZDMeleeWeapon:
		equip_primary_weapon(slot_data)
	else:
		unequip_secondary_weapon()
	
func _on_current_force_updated(force):
	current_move_dir = force
	
	# Arreglo para corregir la dirección
	current_move_dir.y *= -1

func _on_SpecialDash_tween_all_completed():
	doing_special_dash = false
	special_dash_time_accum = 0.0
