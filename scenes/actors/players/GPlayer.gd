extends GActor

class_name GPlayer

# Es la data del player y la logica del mismo
var data : PHCharacter # Este es el que equipa el arma

export (int) var speed = 3000

var move = Vector2.ZERO

var can_fire := false

var reload_progress := 0.0
var need_reload := false
# Tiempo para la proxima accion de la arma
var time_to_next_action := 1.0
# Tiempo de espera entre cada bala
var time_to_next_action_progress := 0.0

# Tiempo para la proxima accion melee
var melee_time_to_next_action := 0.4
# Tiempo de espera entre cada ataque melee
var melee_time_to_next_action_progress := 0.0

# Total current ammo
var total_ammo = -1

# Escena para mostrar el daño en forma numérica
var damage_label = preload("res://scenes/hud/floating_hud/FloatingText.tscn")

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

onready var mobile_selected_pos = get_tree().get_nodes_in_group("GameCamera")

signal fire(dir)
signal dead
signal spawn
signal reload
signal item_taken(item)

func _ready():
	connect("fire", self, "_on_fire")
	
	data.connect("dead", self, "_on_dead")
	data.connect("remove_hp", self, "_on_remove_hp")

	# Al iniciar el data equip se va a null siempre
	# para que no suceda un bug, de un arma fantasma.
	data.equip = null
	
	update_weapon()
	
	if mobile_selected_pos.size() > 0:
		mobile_selected_pos = mobile_selected_pos[0].get_node("MobileSelected/Pos")

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
						$Sprites/Head.rotation_degrees -= delta * 500 * special_dash_time_accum
					else:
						$Sprites/Head.rotation_degrees += delta * 500 * special_dash_time_accum
					
					use_stamina(delta, 0.5)
				else:
					$Sprites/Head.rotation_degrees += 40
				
				is_special_dash = true
				special_dash_state = SpecialDashState.DOING
			return
		SpecialDashState.DOING:
			# Cambiamos las collision layer y mask antes de hacer el
			# dash especial
			collision_layer = 4
			collision_mask = 4
			
			move_and_slide(current_move_dir.normalized() * 4500 * delta * special_dash_time_accum)
			$Sprites/Head.rotation_degrees += 40
			
			if special_dash_time_accum <= 0:
				special_dash_state = SpecialDashState.END
			else:
				special_dash_time_accum -= delta * 4 
			return
		SpecialDashState.END: 
			is_special_dash = false
			doing_dash = false
			doing_special_dash = false
			$Sprites/Head.rotation_degrees = 0
			special_dash_state = SpecialDashState.UNSTATE
			
			collision_layer = 3
			collision_mask = 3
	
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
	if data.equip is PHDistanceWeapon and can_fire and time_to_next_action_progress >= time_to_next_action and data.equip.fire():
		if not Main.is_mobile:
			fire_dir = $GWeaponInBattle/Sprite.get_global_mouse_position() - global_position
		else:
			if selected_enemy:
				fire_dir = selected_enemy.global_position - global_position
			else:
				if current_move_dir != Vector2.ZERO:
					fire_dir = current_move_dir
				else:
					# Necesitamos que fire_dir sea igual a la dirección donde apunta gweaponinbattle
					fire_dir = $GWeaponInBattle/Sprite/Direction.global_position
					
		time_to_next_action_progress = 0.0
		emit_signal("fire", fire_dir.normalized())
	elif not data.equip and melee_time_to_next_action_progress >= melee_time_to_next_action:
		melee_time_to_next_action_progress = 0.0
		melee_attack()
	
func _reload_handler():
	if data.equip is PHDistanceWeapon and total_ammo != 0:
		if reload():
			SoundManager.play(SoundManager.Sound.RELOAD_1)
			reload_progress = 0.0

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
	
	# Equipamiento y reload
	#
		
	if data.equip and time_to_next_action_progress < time_to_next_action:
		time_to_next_action_progress += delta
		return
	elif not data.equip and melee_time_to_next_action_progress < melee_time_to_next_action:
		melee_time_to_next_action_progress += delta
		return
	
	if data.equip is PHDistanceWeapon and data.equip.current_shot == 0 and total_ammo != 0:
		if reload_progress > data.equip.time_to_reload:
			if reload():
				SoundManager.play(SoundManager.Sound.RELOAD_1)
				reload_progress = 0.0
		else:
			reload_progress += delta
	
func update_weapon():
	total_ammo = -1
	
	if data.equip is PHDistanceWeapon:
		$GWeaponInBattle.set_weapon(data.equip)
		can_fire = true
		time_to_next_action = data.equip.time_to_next_action
	else:
		$GWeaponInBattle.set_weapon(null)
		can_fire = false
		
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
	
	# Puede que no exista data ya que el player se
	# puede instanciar directamente.
	if data:
		data.disconnect("item_equiped", self, "_on_item_equiped")

func enable_interact(_can_fire := false):
	visible = true
	can_move = true
	can_fire = _can_fire
	$Collision.disabled = false
	
	data.connect("item_equiped", self, "_on_item_equiped")
	
# Esta funcion se llama mas de lo necesario - Necesita Revisión
# Retorna true si hace reload correctamente y
# false de lo contrario.
func reload():
	# Prevenir que se llame a esta funcion inecesariamente
	if not data.equip is PHDistanceWeapon or data.equip.current_shot >= data.equip.weapon_capacity:
		return false
	
	# Obtener las municiones
	var ammunition_inv = []
	total_ammo = 0
	
	for ammo in DataManager.get_current_inv().inv:
		if ammo is TZDAmmo and ammo.ammo_type == data.equip.ammo_type:
			ammunition_inv.append(ammo)
			total_ammo += ammo.ammo_amount
	
	# Si no hay ammunition_inv entonces se sale de la
	# funcion
	if ammunition_inv.size() < 1:
		return false
	
	for ammo in ammunition_inv:
		if data.equip.reload(ammo):
			break
	
	for i in ammunition_inv.size() - 1:
		if ammunition_inv[i].ammo_amount == 0:
			ammunition_inv.pop_front()
	
	# Para que BulletInfo se actualize
	emit_signal("reload")
	
	return true

func melee_attack():
	$BoxingAttack/Anim.play("box_hit")
	SoundManager.play(SoundManager.Sound.HIT_1)

# Player tiene acceso al hud y lo configura
func set_hud(_hud):
	hud = _hud
	
	# Configurar HUD
	hud.get_node("Analog").connect("current_force_updated", self, "_on_current_force_updated")
	
# Mobile
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

func dash_start():
	doing_dash = true
	dash_dir = current_move_dir.normalized() / 4 * 3
	dash_state = DashState.START
	button_dash_is_pressed = true
	
	$Sprites/AnimMove.stop()
	$Sprites/AnimDash.play("DashStart")
	
func dash_stop():
	doing_dash = false
	
	dash_dir = Vector2.ZERO
	button_dash_is_pressed = false
	
	collision_layer = 3
	collision_mask = 3
	
	$Sprites/AnimDash.play("DashStop")
	$Sprites/Head.rotation_degrees = 0

func _on_dead():
	is_mark_to_dead = true
	disable_player(true)
	$Sprites/AnimDead.play("Dead")
	SoundManager.play(SoundManager.Sound.PLAYER_DEAD_1)

func _on_remove_hp(amount):
	if is_inmortal: return

	$Sprites/AnimHit.play("Hit")
	
	# Instancia un label indicando el daño recibido y lo agrega al árbol
	var dmg_label : FloatingText = damage_label.instance()
	dmg_label.init(amount, FloatingText.Type.DAMAGE)
	dmg_label.position = global_position
	get_parent().add_child(dmg_label)

func _on_item_equiped(item):
	update_weapon()

func _on_fire(dir):
	# Temp
	var bullet = ShootManager.fire(dir, data.equip.ammo_type, data.equip.damage)
	bullet.global_position = $GWeaponInBattle/Sprite/FireSpawn.global_position
	bullet.rotation = $GWeaponInBattle/Sprite.rotation
	get_parent().add_child(bullet)

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Dead":
		visible = false
		.dead()

func _on_InteractArea_body_entered(body):
	if body is ItemInWorld:
		if DataManager.inventories.size() > 0:
			body.take_item(DataManager.inventories[DataManager.current_player])
			total_ammo = -1
			emit_signal("item_taken", body.data)
	elif body is GBullet and not is_inmortal:
		data.damage(body.damage)
		body.dead()
	elif body is GBullet and is_inmortal:
		body.dead()

func _on_DetectArea_body_entered(body):
	if body is GActor:
		if body == self:
			return
		
		selectables.append(body)
		
		if selectables.size() == 1:
			select_next()
	
func _on_DetectArea_body_exited(body):
	if body is GActor:
		if body == self:
			return
		
		if selectables.has(body) or body.has_meta("structure_owner"):
			var enemy_exited_num = selectables.find(body)
			selectables.remove(enemy_exited_num)
			
			if selected_num == enemy_exited_num:
				select_next()
			
			if selectables.size() == 0:
				selected_enemy = null

func _on_current_force_updated(force):
	current_move_dir = force
	
	# Arreglo para corregir la dirección
	current_move_dir.y *= -1

func _on_SpecialDash_tween_all_completed():
	doing_special_dash = false
	special_dash_time_accum = 0.0
