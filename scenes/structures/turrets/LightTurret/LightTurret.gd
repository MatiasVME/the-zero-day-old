# LightTurret - Torreta Ligera
extends GTurret

# Velocidad del rotator en rad/s, posiblemente se cambie a RPS
var rotator_velocity = 3.5

export (int) var attack := 2
export (float) var attack_delay := 0.4

var attack_delay_end := false

var track_distance := 75

var patrol_objetive : Vector2 = Vector2(0,-1)
var patrol_delay := 2.0
var patrol_time := 0.0

# Collider que encuentra con el raycast
var collider

onready var objective = null
 
func _init():
	structure_size = StructureSize.S1X1

func _ready():
	patrol_objetive = get_random_objective()
	
	# Su modo por defecto sera PATROL
	state = State.PATROL
	
	$Base.playing = true
	$AttackDelay.set_wait_time(attack_delay)
	
	# DamageArea
	$DamageArea.connect("body_entered", self, "_on_DamageArea_body_entered")

	# DetectArea
	$DetectArea.connect("body_entered", self, "_on_DetectArea_body_entered")
	$DetectArea.connect("body_exited", self, "_on_DetectArea_body_exited")
	
	$AttackDelay.connect("timeout", self, "_on_AttackDelay_timeout")
	
	.spawn()
	
	data.max_hp = int(round(rand_range(50, 70)))
	data.restore_hp()
	data.xp_drop = 5 # temp
	
	data.connect("dead", self, "_on_dead")
	#data.connect("drop_xp", self, "_on_drop_xp")
	
func _physics_process(delta):
	match state:
		State.SLEEP:
			state = State.PATROL
		State.PATROL:
			rot_pivot_to(patrol_objetive, delta)
			patrol_time += delta
			if patrol_time >= patrol_delay:
				patrol_time = 0
				patrol_objetive = get_random_objective()
		State.TRACK:
			if rot_pivot_to(objective.global_position, delta):
				collider = $Pivot/RayCanFire.get_collider()
				if collider and collider.is_in_group("Player"): shoot()
				
				state = State.SHOOT
				attack_delay_end = false
				$AttackDelay.start()
		State.SHOOT:
			if objective.is_mark_to_dead : patrol()
			
			if not rot_pivot_to(objective.global_position, delta):
				track()
				
			collider = $Pivot/RayCanFire.get_collider()
			
			if attack_delay_end and collider and collider.is_in_group("Player"): 
				shoot()
				attack_delay_end = false
				$AttackDelay.start()
		State.DESTROYED:
			if not is_mark_to_destroy:
				is_mark_to_destroy = true
				.destroy()

# Rotara el pivot hacia el objetivo, devolvera TRUE si lo apunta directamente
func rot_pivot_to(objective_pos, delta) -> bool:
	var angle = $Pivot.get_angle_to(objective_pos)
	if abs(angle) < rotator_velocity*delta: 
		$Pivot.look_at(objective_pos)
		return true

	if angle > 0:
		$Pivot.rotation += rotator_velocity*delta
	elif angle < 0:
		$Pivot.rotation -= rotator_velocity*delta	

	return false

func get_random_objective():
	
	var x = rand_range(-1,1)
	var y = rand_range(-1,1)
	
	return global_position + Vector2(x,y)
	
func patrol():
	state = State.PATROL
	patrol_time = 0
	$Pivot/Rotator.animation = "Idle"

func track():
	state = State.TRACK

func shoot():
	var bullet = ShootManager.fire(
		(objective.global_position - global_position).normalized(),
		ShootManager.Bullet.NORMAL,
		attack
	)
	
	bullet.global_position = $Pivot/ShootPivot.global_position
	bullet.rotation = $Pivot.rotation
	bullet.bullet_owner = self
	get_parent().add_child(bullet)
	
	$Pivot/Rotator.frame = 0
	$Pivot/Rotator.play("Shoot")
	.shoot()

func _on_DetectArea_body_entered(body):
	if body as GPlayer:
		track()
		objective = body
		.detect()
		$Sounds/Alert1.play()
		
func _on_drop_xp(amount):
	# TEMP
	DataManager.get_current_player_instance().add_xp(amount)
	
func _on_DetectArea_body_exited(body):
	if body as GPlayer:
		patrol()
		patrol_objetive = objective.global_position
		objective = null
	
func _on_dead():
	change_state(State.DESTROYED)
	
func _on_DamageArea_body_entered(body):
	if body is GBullet and not is_mark_to_destroy:
		$Sounds/Hit1.play()
		body.dead()
		.damage(body.damage)

func _on_AttackDelay_timeout():
	$AttackDelay.stop()
	attack_delay_end = true