extends GEnemy

class_name EDogbot

var objective
var objectives := []
var velocity := Vector2.ZERO
export (float) var max_speed := 50.0
export (float) var mass := 2.0

# Es solo para el area de ataque
var in_attack_area := []
# Cada cuanto tiempo ataca
export (float) var pulse_attack_time := 0.6
# Tiempo acumulado para el proximo ataque
var accum_pulse_attack_time := 0.0

func _ready():
	self.actor_name = "Dogbot"
	
	state = State.STAND
	
	$Body.playing = true
	$DamageDelay.set_wait_time(0.2)
	
	randomize()
	
	data.max_hp = int(round(rand_range(20, 30)))
	data.restore_hp()
	data.xp_drop = 2 # temp
	data.attack = 6
	data.money_drop = int(rand_range(30, 60))
	
	data.connect("dead", self, "_on_dead")
	
func _physics_process(delta):
	match state:
		State.STAND: state_stand()
		State.SEEKER: state_seeker(delta)
		State.ATTACK: state_attack(delta)
		State.DIE: state_die()

func state_stand():
	if not $Sprites/AnimIdle.is_playing(): 
		$Sprites/AnimRun.stop()
		$Sprites/AnimAttack.stop()
		$Sprites/AnimIdle.play("Idle")
		
	if is_instance_valid(objective):
		change_state(State.SEEKER)
	elif objectives.size() > 0:
#		objective = in_attack_area[in_attack_area.size() - 1]
		objective = objectives[(objectives.find(objective) + 1) % objectives.size()]
	
#	print_debug(in_attack_area)
		
func state_seeker(delta):
	if is_instance_valid(objective) and in_attack_area.size() == 0:
		sekeer(objective.global_position, delta)
		
		if not $Sprites/AnimRun.is_playing():
			$Sprites/AnimIdle.stop()
			$Sprites/AnimAttack.stop()
			$Sprites/AnimRun.play("Run")
	elif is_instance_valid(objective) and in_attack_area.size() > 0:
		change_state(State.ATTACK)
	else:
		change_state(State.STAND)
	
func state_attack(delta):
	if is_instance_valid(objective):
		sekeer(objective.global_position, delta)
	
	if in_attack_area.size() > 0:
		if accum_pulse_attack_time >= pulse_attack_time:
			for actor in in_attack_area:
				if is_instance_valid(actor):
					actor.damage(data.attack, self)
				else:
					in_attack_area.erase(actor)
					
#					if in_attack_area.size() > 0:
#						_on_AttackArea_body_entered(in_attack_area[0])
#						print_debug(in_attack_area[0])
					
					change_state(State.STAND)
					
			accum_pulse_attack_time = 0.0
			
			if not $Sprites/AnimAttack.is_playing():
				$Sprites/AnimIdle.stop()
				$Sprites/AnimRun.stop()
				$Sprites/AnimAttack.play("Attack")
		else:
			accum_pulse_attack_time += delta
	else:
		change_state(State.STAND)
	
func state_die():
	pass

# Rutina en caso de que vea al objetivo
func sekeer(_objective : Vector2, delta):
	$Navigator.time_current += delta
	
	if $Navigator.can_navigate and $Navigator.time_current >= $Navigator.time_to_update_path and state == State.SEEKER:
		$Navigator.update_path(_objective)
	
	if velocity.x > 0:
		if $Sprites.scale.x == 1:
			$Sprites.scale.x = -1
	elif velocity.x < 0:
		if $Sprites.scale.x == -1:
			$Sprites.scale.x = 1
	
	if state == State.SEEKER and $Navigator.can_navigate and not $Navigator.out_of_index:
		var current_point = $Navigator.get_current_point()
		
		if not current_point:
			current_point = _objective
		
		velocity = Steering.follow(
			velocity,
			global_position,
			current_point,
			100.0
		)
		move_and_slide(velocity)
		
		var b_point
		if $Navigator.navigation_path.size() - 1 -$Navigator.current_index < 1 :
			b_point = _objective
		else:
			b_point = $Navigator.navigation_path[$Navigator.current_index + 1]
		
#		print_debug("$Navigator.navigation_path", $Navigator.navigation_path.size())
		
		var AB = b_point.distance_to(current_point)
		var b_dist = global_position.distance_to(b_point)
		if b_dist <= AB:
			$Navigator.next_index()
	else:
		velocity = Steering.follow(
			velocity,
			global_position,
			_objective,
			100.0
		)
		move_and_slide(velocity)
		
#		print_debug("not navigator")

func change_state(_state):
	if _state == State.SEEKER and $Navigator.can_navigate:
		$Navigator.time_current = $Navigator.time_to_update_path
	
	print_debug("Dogbot State: ", _state)
	
	.change_state(_state)

func _on_dead():
	pass
	
func _on_DetectArea_body_entered(body):
	if body is GPlayer:
		objective = body
		objectives.append(body)
	elif body is EGluton:
		objective = body
		objectives.append(body)

func _on_DetectArea_body_exited(body):
	if body is GPlayer:
		objective = null
		objectives.remove(objectives.find(body))
	elif body is EGluton:
		objective = null
		objectives.remove(objectives.find(body))

func _on_AttackArea_body_entered(body):
	if body is GPlayer:
		in_attack_area.append(body)
	elif body is EGluton:
		in_attack_area.append(body)

func _on_AttackArea_body_exited(body):
	if body is GPlayer:
		in_attack_area.remove(in_attack_area.find(body))
	if body is EGluton:
		in_attack_area.remove(in_attack_area.find(body))