extends GEnemy

var objective
var velocity := Vector2.ZERO
var max_speed := 50.0
var mass := 2.0

func _ready():
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
		State.SEEKER: state_seeker()
		State.ATTACK: state_attack()
		State.DIE: state_die()

func state_stand():
	if not $Sprites/AnimIdle.is_playing(): 
		$Sprites/AnimRun.stop()
		$Sprites/AnimIdle.play("Idle")
		
	if is_instance_valid(objective):
		change_state(State.SEEKER)

func state_seeker():
	if is_instance_valid(objective):
		sekeer(objective.global_position)
		
		if not $Sprites/AnimRun.is_playing():
			$Sprites/AnimIdle.stop()
			$Sprites/AnimRun.play("Run")
	
func state_attack():
	pass
	
func state_die():
	pass

# Rutina en caso de que vea al objetivo
func sekeer(_objective : Vector2):
	if $Navigator.can_navigate and $Navigator.time_current >= $Navigator.time_to_update_path and state == State.SEEKER:
		$Navigator.update_path(_objective)
	
#	match get_direction_to_see(_objective):
#		90:
#			if $Body.flip_h:
#				$Body.flip_h = false
#			$Body.play("RunSide")
#		-90:
#			if !$Body.flip_h:
#				$Body.flip_h = true
#			$Body.play("RunSide")
			
	if state == State.SEEKER and $Navigator.can_navigate and not $Navigator.out_of_index:
		var current_point = $Navigator.get_current_point()
		
		if not current_point:
			current_point = _objective
		
		velocity = Steering.follow(
			velocity,
			global_position,
			current_point,
			max_speed,
			mass
		)
		move_and_slide(velocity)
		
		var b_point
		if $Navigator.navigation_path.size()-1 -$Navigator.current_index < 1 :
			b_point = _objective
		else:
			b_point = $Navigator.navigation_path[$Navigator.current_index + 1]
			
		var AB = b_point.distance_to(current_point)
		var b_dist = global_position.distance_to(b_point)
		if b_dist <= AB:
			$Navigator.next_index()
		
#		print_debug("navigator")
	else:
		velocity = Steering.follow(
			velocity,
			global_position,
			_objective,
			max_speed,
			mass
		)
		move_and_slide(velocity)
		
		print_debug("not navigator")

func _on_dead():
	pass
	
func _on_DetectArea_body_entered(body):
	if body is GPlayer:
		objective = body

func _on_DetectArea_body_exited(body):
	if body is GPlayer:
		objective = null
