# LightTurret - Torreta Ligera
extends GTurret

# Velocidad del rotator en rad/s, posiblemente se cambie a RPS
var rotator_velocity = 3.5

var attack : int = 2
var attack_delay : float= 0.4

var attack_delay_end : bool = false

var track_distance : float = 75

var patrol_objetive : Vector2 = Vector2(0,-1)

onready var objective = null


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

	# PatrolDelay
	# Cambiara de objetivo random cada 2 seg
	$PatrolDelay.connect("timeout", self, "_on_PatrolDelay_timeout")
	$PatrolDelay.set_wait_time(2)
	$PatrolDelay.start()
	
	$AttackDelay.connect("timeout", self, "_on_AttackDelay_timeout")
	
	.spawn()
	
	data.hp = 20
	data.xp_drop = 30 # temp
	
	data.connect("destroy", self, "_on_destroy")
	#data.connect("drop_xp", self, "_on_drop_xp")
	
func _physics_process(delta):
	match state:
		State.SLEEP:
			state = State.PATROL
		State.PATROL:
			rot_pivot_to(patrol_objetive, delta)
		State.TRACK:
			if rot_pivot_to(objective.global_position, delta):
				shoot()
				state = State.SHOOT
				attack_delay_end = false
				$AttackDelay.start()
		State.SHOOT:
			if not rot_pivot_to(objective.global_position, delta):
				track()
			if attack_delay_end : 
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
	$PatrolDelay.start()
	$Pivot/Rotator.animation = "Idle"

func track():
	state = State.TRACK
	$PatrolDelay.stop()

func shoot():
	var bullet = ShootManager.fire(
		(objective.global_position - global_position).normalized(),
		ShootManager.Bullet.COMMON_BULLET,
		attack
	)
	
	bullet.global_position = $Pivot/ShootPivot.global_position
	bullet.rotation = $Pivot.rotation
	get_parent().add_child(bullet)
	
	$Pivot/Rotator.frame = 0
	$Pivot/Rotator.play("Shoot")
	.shoot()

func _on_DetectArea_body_entered(body):
	if body as GPlayer:
		track()
		objective = body
		.detect()
		
func _on_drop_xp(amount):
	# TEMP
	DataManager.get_current_player_instance().add_xp(amount)
	
func _on_DetectArea_body_exited(body):
	print(body)
	
	if body as GPlayer:
		patrol()
		patrol_objetive = objective.global_position
		objective = null
	
func _on_destroy():
	change_state(State.DESTROYED)
	
func _on_DamageArea_body_entered(body):
	if body is GBullet and not is_mark_to_destroy:
		SoundManager.play(SoundManager.Sound.HIT_1) # Por ahora usara el sonido de M
		body.dead()
		.damage(1) # temp
	
func _on_PatrolDelay_timeout():
	patrol_objetive = get_random_objective()

func _on_AttackDelay_timeout():
	$AttackDelay.stop()
	attack_delay_end = true