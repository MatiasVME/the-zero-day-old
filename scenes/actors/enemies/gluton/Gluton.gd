# Aqui van las caracteristicas del enemigo Gluton

extends "res://scenes/actors/enemies/GEnemy.gd"

const MAX_SPEED = 50
const MAX_FORCE = 0.02

var velocity = Vector2()

export (int, "SEEK", "FLEE") var mode = 0

var hp : int = 10
var speed : int = 3
var attack : int = 2

var view_distance : float = 10
var attack_distance : float = 1

# Objetivo random cuando no esta haciendo nada
var random_objective : Vector2 = Vector2()

onready var objective = null

func _ready():
	state = State.RANDOM_WALK
	
	$Body.playing = true
	$DamageDelay.set_wait_time(0.2)
	
	.spawn()
	
	randomize()
	random_objective = Vector2(rand_range(-200, -200), rand_range(200, 200))
	
func _physics_process(delta):
	if hp <= 0 and not $Anim.current_animation == "dead":
		change_state(State.DIE)
		
	match state:
		State.SEEKER:
			if objective and hp > 3:
				sekeer(objective)
				
				if self.hp < 3:
					change_state(State.RUN)
			else:
				change_state(State.RANDOM_WALK)
		State.RUN:
			if objective:
				run(objective)
			else:
				change_state(State.RANDOM_WALK)
		State.ATTACK:
			objective.damage(10)
			if global_position.distance_to(objective.global_position) > 20:
				change_state(State.SEEKER)
			if hp < 3:
				change_state(State.RUN)
		State.DIE:
			if not $Anim.current_animation == "dead":
				.dead()
		State.RANDOM_WALK:
			if not objective:
				random_movement(random_objective)
			if hp < 3 and objective:
				change_state(State.RUN)
			if hp > 3 and objective:
				change_state(State.SEEKER)

# Devuelve la direccion en grados
func get_direction_to_see(objective):
	if round(transform.origin.angle_to_point(objective)) == 2:
		return 0
	elif round(transform.origin.angle_to_point(objective)) == -2:
		return 180
	elif round(transform.origin.angle_to_point(objective)) == 0:
		return -90
	elif round(transform.origin.angle_to_point(objective)) == 3:
		return 90
	else:
		return $Body.get_animation()
		
# Rutina en caso de que vea al objetivo
func sekeer(objective): 
	match get_direction_to_see(objective.global_position):
		0:
			$Body.play("Run_Up")
		180:
			$Body.play("Run_Down")
		90:
			if $Body.flip_h:
				$Body.flip_h = false
			$Body.play("Run_Side")
		-90:
			if !$Body.flip_h:
				$Body.flip_h = true
			$Body.play("Run_Side")
	
#	move_and_slide((objective.global_position - global_position).normalized() * speed * 5)
	velocity = steer(objective.global_position)
	move_and_slide(velocity)
	
# Rutina en caso de tener que huir del objetivo
func run(objective):
	match get_direction_to_see(objective.global_position):
		0:
			$Body.play("Run_Down")
		180:
			$Body.play("Run_Up")
		90:
			if !$Body.flip_h:
				$Body.flip_h = true
			$Body.play("Run_Side")
		-90:
			if $Body.flip_h:
				$Body.flip_h = false
			$Body.play("Run_Side")
	
	velocity = steer(objective.global_position)
	move_and_slide(velocity)
	
func random_movement(random_objective):
	match get_direction_to_see(random_objective):
		0:
			$Body.play("Run_Up")
		180:
			$Body.play("Run_Down")
		90:
			if $Body.flip_h:
				$Body.flip_h = false
			$Body.play("Run_Side")
		-90:
			if !$Body.flip_h:
				$Body.flip_h = true
			$Body.play("Run_Side")
			
	move_and_slide((random_objective - global_position).normalized() * speed * 6)

func steer(target : Vector2):
	var desired_velocity = (target - position).normalized() * MAX_SPEED
	
	if state == State.RUN:
		desired_velocity = -desired_velocity
	
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	
	return(target_velocity)

func _on_DetectArea_body_entered(body):
	if body as GPlayer:
		objective = body
		
func _on_DetectArea_body_exited(body):
	if body as GPlayer:
		objective = null
	
func _on_DamageDelay_timeout():
	can_damage = true
	
func _on_DamageArea_body_entered(body):
	if body is GBullet:
		.damage(1)
		hp -= 1
	