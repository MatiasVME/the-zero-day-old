extends GActor

class_name GPlayer

# Es la data del player y la logica del mismo
var data : PHCharacter # Este es el que equipa el arma

export (int) var speed = 2500

var move_x
var move_y

var input_dir : Vector2 = Vector2()
var input_run : bool = false

var can_move : bool = false
var can_fire : bool = false

var is_disabled = false

signal fire(dir)
signal dead
signal spawn
signal reload
signal item_taken(item)

func _ready():
	connect("fire", self, "_on_fire")
	
	data.connect("dead", self, "_on_dead")
	data.connect("remove_hp", self, "_on_remove_hp")
	
	update_weapon()

func _physics_process(delta):
	if not can_move or is_disabled:
		return
		
	input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	input_run = Input.is_action_pressed("run")
	
	if not input_run:
		move_x = input_dir.x * speed * delta
		move_y = input_dir.y * speed * delta
		$Sprite.speed_scale = 0.6
	else:
		move_x = input_dir.x * speed * 2 * delta
		move_y = input_dir.y * speed * 2 * delta
		$Sprite.speed_scale = 1.2
	
	if input_dir == Vector2.LEFT:
		$Anim.play("MoveSide")
		$Sprite.flip_h = true
	elif input_dir.x == -1 and input_dir.y == -1:
		$Anim.play("MoveUp")
	elif input_dir == Vector2.UP:
		$Anim.play("MoveUp")
	elif input_dir.x == 1 and input_dir.y == -1:
		$Anim.play("MoveUp")
	elif input_dir == Vector2.RIGHT:
		$Anim.play("MoveSide")
		$Sprite.flip_h = false
	elif input_dir.x == 1 and input_dir.y == 1:
		$Anim.play("MoveDown")
		$Sprite.flip_h = false
	elif input_dir == Vector2.DOWN:
		$Anim.play("MoveDown")
		$Sprite.flip_h = false
	elif input_dir.x == -1 and input_dir.y == 1:
		$Anim.play("MoveDown")
		$Sprite.flip_h = false
	else:
		if $Anim.current_animation != "Idle" and $Anim.current_animation != "hit" or not $Anim.is_playing():
			$Anim.play("Idle")
			$Sprite.speed_scale = 0.1
		
	if move_x != 0 and move_y != 0:
		move_x /= 1.5
		move_y /= 1.5
		
	move_and_slide(Vector2(move_x, move_y), Vector2())
	
	# Puede disparar? Se preciono fire?
	if data.equip is PHDistanceWeapon and can_fire and Input.is_action_just_pressed("fire") and data.equip.fire():
		var dir = ($GWeaponInBattle/Sprite.get_global_mouse_position() - global_position).normalized()
		emit_signal("fire", dir)
	elif data.equip is PHDistanceWeapon and data.equip.current_shot == 0:
		reload()

func update_weapon():
	$GWeaponInBattle.set_weapon(data.equip)
	
	if not data.equip:
		can_fire = false

	if data.equip is PHWeapon:
		can_fire = true
	
func disable_player(_visible : = false):
	is_disabled = true
	visible = _visible
	can_move = false
	can_fire = false
	$Collision.disabled = true
	
	# Puede que no exista data ya que el player se
	# puede instanciar directamente.
	if data:
		data.disconnect("item_equiped", self, "_on_item_equiped")
	
func enable_player(_can_fire : bool = false):
	is_disabled = false
	visible = true
	can_move = true
	can_fire = _can_fire
	$Collision.disabled = false
	
	data.connect("item_equiped", self, "_on_item_equiped")

# Esta funcion se llama mas de lo necesario - Necesita Revisión
func reload():
	# Prevenir que se llame a esta funcion inecesariamente
	if not data.equip is PHDistanceWeapon:
		return
	if data.equip.current_shot >= data.equip.weapon_capacity:
		return
	
	# Obtener las municiones
	var ammunition_inv = []
	
	for ammo in DataManager.get_current_inv().inv:
		if ammo is PHAmmo:
			ammunition_inv.append(ammo)
	
	# Si no hay ammunition_inv entonces se sale de la
	# funcion
	if ammunition_inv.size() < 1:
		return
	
	for ammo in ammunition_inv:
		if data.equip.reload(ammo):
			break
	
	for i in ammunition_inv.size() - 1:
		if ammunition_inv[i].ammo_amount == 0:
			ammunition_inv.pop_front()
	
	# Para que BulletInfo se actualize
	emit_signal("reload")

func _on_dead():
	is_mark_to_dead = true
	disable_player(true)
	$Anim.play("dead")
	SoundManager.play(SoundManager.Sound.PLAYER_DEAD_1)

func _on_remove_hp(amount):
	$Anim.play("hit")

func _on_item_equiped(item):
	update_weapon()

func _on_GetArea_body_entered(body):
	if body is ItemInWorld:
		if DataManager.inventories.size() > 0:
			body.take_item(DataManager.inventories[DataManager.current_player])
			emit_signal("item_taken", body.data)

func _on_fire(dir):
	# Temp
	var bullet = ShootManager.fire(dir)
	bullet.global_position = $GWeaponInBattle/Sprite/FireSpawn.global_position
	get_parent().add_child(bullet)

func _on_Anim_animation_finished(anim_name):
	if anim_name == "dead":
		visible = false
		
