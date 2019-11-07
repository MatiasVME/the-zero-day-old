# Aqui van las caracteristicas del enemigo Gluton

extends "res://scenes/actors/enemies/GEnemy.gd"

# Enemy gluton
class_name EGluton

const MAX_SPEED = 50
const MAX_FORCE = 0.02
const RANDOM_RUN_DISTANCE = 4

var velocity := Vector2.ZERO

#export (State) const mode = 0

var speed : int = 3
var attack : int = 2

var view_distance : float = 10
var attack_distance : float = 18 # Igual que el AttackArea

# Objetivo random cuando no esta haciendo nada
var random_objective := Vector2()
var time_to_random_objective := 4.0
var current_time_to_random_objective := 0

# Ultima posicion del objetivo
var last_objective_position : Vector2

onready var objective

# Se usa para atacar solo una vez
var ot_attack = true

func _ready():
	self.actor_name == "Gluton"
	self.actor_owner = Enums.ActorOwner.ENEMY
	data.character_owner = self.actor_owner
	
	state = State.RANDOM_WALK
	
	$Sprites/Body.playing = true
#	$DamageDelay.set_wait_time(0.2)
	
	.spawn()
	
	randomize()
	random_objective = get_rand_objective()
	
	data.max_hp = int(round(rand_range(20, 30)))
	data.restore_hp()
	data.xp_drop = 1 # temp
	data.attack = 3
	data.money_drop = int(rand_range(30, 60))
	
	data.connect("dead", self, "_on_dead")
	data.connect("drop_xp", self, "_on_drop_xp")
	
func _physics_process(delta):
	match state:
		State.SEEKER:
			if objective and not objective.is_mark_to_dead and data.hp > 3:
				if $Navigator.can_navigate:
					$Navigator.time_current += delta
				
				sekeer(objective.global_position)
				
				if data.hp < int(data.max_hp / 3):
					change_state(State.RUN)
				elif objective.actor_name == "Dogbot":
					change_state(State.RUN)
			else:
				change_state(State.RANDOM_WALK)
		State.RUN:
			if objective and not objective.is_mark_to_dead:
				run(objective.global_position)
			else:
				change_state(State.RANDOM_WALK)
		State.ATTACK:
			if objective and objective.is_mark_to_dead :
				change_state(State.RANDOM_WALK)
				return
			elif objective and objective.actor_name == "Dogbot":
				change_state(State.RUN)
				return
			elif not objective:
				return
			
			$Sprites/Body.look_at(objective.position)
			$Sprites/Body.flip_h = false
			
			if $Sprites/Body.frame == 10 and ot_attack:
				ot_attack = false
				objective.damage(data.attack, self)
				$Sounds/Hit.play()
			elif $Sprites/Body.frame == 11:
				ot_attack = true
		State.DIE:
			if not is_mark_to_dead:
				is_mark_to_dead = true
				$Sounds/Dead.play()
				.dead()
		State.RANDOM_WALK:
			if current_time_to_random_objective >= time_to_random_objective:
				_get_new_random_objective()
			if not objective or objective.is_mark_to_dead:
				sekeer(random_objective)
			elif data.hp < 3 and objective and not objective.is_mark_to_dead:
				change_state(State.RUN)
			elif data.hp > 3 and objective and not objective.is_mark_to_dead:
				change_state(State.SEEKER)
			current_time_to_random_objective += delta
		State.STUNNED:
			stunned(delta)
				
func change_state(_state):
	if _state == State.SEEKER and $Navigator.can_navigate:
		$Navigator.time_current = $Navigator.time_to_update_path
	.change_state(_state)

# Devuelve la direccion en grados
func get_direction_to_see(objective):
	var dir_degree = rad2deg((objective - global_position).normalized().angle())

	if dir_degree > -150 and dir_degree < -60:
#		print("up")
		return 0
	elif dir_degree > -60 and dir_degree < 60:
#		print("right")
		return 90
	elif dir_degree > 60 and dir_degree < 150:
#		print("down")
		return 180
	else:
#		print("left")
		return -90
	
# Rutina en caso de que vea al objetivo
func sekeer(objective):
	if $Navigator.can_navigate and $Navigator.time_current >= $Navigator.time_to_update_path and state == State.SEEKER:
		$Navigator.update_path(objective)
	
	match get_direction_to_see(objective):
		90:
			if $Sprites/Body.flip_h:
				$Sprites/Body.flip_h = false
			$Sprites/Body.play("RunSide")
		-90:
			if !$Sprites/Body.flip_h:
				$Sprites/Body.flip_h = true
			$Sprites/Body.play("RunSide")
			
	if state == State.SEEKER and $Navigator.can_navigate and not $Navigator.out_of_index:
		
		var current_point = $Navigator.get_current_point()
		
		if not current_point:
			current_point = objective
		
		velocity = steer(current_point)
		move_and_slide(velocity)
		
		var b_point
		if $Navigator.navigation_path.size()-1 -$Navigator.current_index < 1 :
			b_point = objective
		else:
			b_point = $Navigator.navigation_path[$Navigator.current_index + 1]
			
		var AB = b_point.distance_to(current_point)
		var b_dist = global_position.distance_to(b_point)
		if b_dist <= AB:
			$Navigator.next_index()

	else:
		velocity = steer(objective)
		move_and_slide(velocity)

# Rutina en caso de tener que huir del objetivo
func run(objective):
	match get_direction_to_see(objective):
		90:
			if !$Sprites/Body.flip_h:
				$Sprites/Body.flip_h = true
			$Sprites/Body.play("RunSide")
		-90:
			if $Sprites/Body.flip_h:
				$Sprites/Body.flip_h = false
			$Sprites/Body.play("RunSide")
	
	velocity = steer(objective)
	move_and_slide(velocity * 2)
	
# Rutina cuando es impactado por un proyectil con Knockback
func stunned(delta : float):
	var collider = move_and_collide(velocity * delta)
	velocity *= 0.9
	if velocity.length() < 1.0 and not (state == State.ATTACK or state == State.DIE):
		change_state(State.RANDOM_WALK)
	
func steer(target : Vector2):
	var desired_velocity = (target - position).normalized() * MAX_SPEED
	
	if state == State.RUN:
		desired_velocity = -desired_velocity
	
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	
	return(target_velocity)

# Se supone que esta funcion deberia ser 
# mas inteligente que la anterior :S
func get_rand_objective():
	var rand_objective := Vector2()
	
	random_objective = Vector2(
		rand_range(500, -500),
		rand_range(500, -500)
	) + global_position
	
	return random_objective
	
func drop_item():
	var rand_num = rand_range(0, 100)
	
	# Si el numero no esta dentro de la probabilidad, entonces return
	if rand_num > 25:
		return
	
	var item_pos := Vector2(
		rand_range(10, 10),
		rand_range(-10, -10)
	)
	
	# Los glutones normales pueden dropear balas normales y raramente armas.
	#
	if rand_num < 22.5:
		var normal_ammo
		
		if rand_num < 2.5:
			normal_ammo = Factory.ItemInWorldFactory.create_normal_ammo(64)
		elif rand_num < 5:
			normal_ammo = Factory.ItemInWorldFactory.create_normal_ammo(32)
		else:
			normal_ammo = Factory.ItemInWorldFactory.create_normal_ammo(16)
		
		normal_ammo.position = global_position + item_pos
		get_parent().add_child(normal_ammo)
	else:
		var weapon = Factory.ItemInWorldFactory.create_rand_distance_weapon(data.level, 1)
		get_parent().add_child(weapon)
		weapon.position = global_position + item_pos
	
func _on_drop_xp(amount):
	if was_attacked_by_a_player():
		DataManager.get_current_player_instance().add_xp(amount)
	
func _on_DamageDelay_timeout():
	can_damage = true

func _on_dead():
	drop_item()
	.dead()
	
func _get_new_random_objective():
	random_objective = get_rand_objective()
	current_time_to_random_objective = 0

func knockback(from : Vector2, impulse :float = 1) -> void:
	velocity = (global_position - from).normalized() * impulse

# Funcion que se define cuando un enemigo es aplastable
func crushed() -> void:
	# TODO: Definir el comportamieto cuado es aplastado
	change_state(State.DIE)
	
func _on_Detect_body_entered(body):
	if body is GPlayer:
		objective = body
	elif body is GActor and body.actor_name == "Dogbot":
		objective = body
	
func _on_Detect_body_exited(body):
	if body as GPlayer:
		random_objective = get_rand_objective()
		objective = null
	elif body is GActor and body.actor_name == "Dogbot":
		objective = null

func _on_Damage_body_entered(body):
	if body is GBullet and not is_mark_to_dead:
		body.dead()
		
		.damage(body.damage, body.bullet_owner)
		
		if body.get("repulsion") and state != State.DIE:
			change_state(State.STUNNED)
			knockback(body.global_position, body.repulsion)
		
		if not data.is_dead: $Sounds/Damage.play()

func _on_Attack_body_entered(body):
	if body is GPlayer:
		change_state(State.ATTACK)
		$Sprites/Body.play("Attack")

func _on_Attack_body_exited(body):
	if body is GPlayer:
		$Sprites/Body.rotation_degrees = 0
		change_state(State.SEEKER)