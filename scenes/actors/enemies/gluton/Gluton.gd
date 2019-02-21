# Aqui van las caracteristicas del enemigo Gluton

extends "res://scenes/actors/enemies/GEnemy.gd"

var hp:int = 10
var speed:int = 2
var attack:int = 2

var view_distance:float = 10
var attack_distance:float = 1

var objective:Vector2

func _ready():
	self.state = 2

func _physics_process(delta):
	
	match state:
		0: #STAND
			$Body.play("Idle")
		1: #SEEKER
			pass
		2: #RUN
			objective = get_global_mouse_position()
			play_animation(objective)
			move_and_slide(get_direction(get_global_mouse_position()).normalized()*5)
		3: #ATTACK
			pass


func get_direction(objective):
	if transform.origin.angle_to_point(objective) < 2.5 and transform.origin.angle_to_point(objective) > 0.5:
		return Vector2(0, 1)
	elif transform.origin.angle_to_point(objective) > -2.5 and transform.origin.angle_to_point(objective) < -0.5:
		return Vector2(0, -1)
	elif transform.origin.angle_to_point(objective) < 0.5 and transform.origin.angle_to_point(objective) > -0.5:
		return Vector2(1, 0)
	elif transform.origin.angle_to_point(objective) > 2.5 and transform.origin.angle_to_point(objective) < -2:
		return Vector2(-1, 0)
	else:
		return Vector2(0, 0)

func get_direction_to_see(objective): #Devuelve la direccion en grados
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

func get_direction_to_see_inverse(objective): #Devuelve la direccion en grados
	if round(transform.origin.angle_to_point(objective)) == 2:
		return 180
	elif round(transform.origin.angle_to_point(objective)) == -2:
		return 0
	elif round(transform.origin.angle_to_point(objective)) == 0:
		return 90
	elif round(transform.origin.angle_to_point(objective)) == 3:
		return -90
	else:
		return $Body.get_animation()

func play_animation(objective):
	if state == 2:
		match get_direction_to_see_inverse(objective):
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
	else:
		match get_direction_to_see(objective):
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