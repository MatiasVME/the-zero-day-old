extends Vehicle

class_name Car

# Properties
export (float) var MAX_VELOCITY = 7000
export (float) var MAX_VELOCITY_REVERSE = -3000
export (float) var MIN_VELOCITY = 200
export (float) var ACCELERATION = 4000
export (float) var DESACCELERATION = 170
export (float) var ANGULAR_VELOCITY = 20
export (float) var ANIM_SPEED_FACTOR = 5

const DEG_CHANGE_ANIM : float = 30.0
var min_velocity_to_stop : float = 1 + DESACCELERATION * ( 1.0 / 60.0 )
var dir_move : Vector2
var dir_rotation : float
var current_speed : float

var pilot

onready var base : = $Base

func _ready():
	current_speed = 0
	dir_move = Vector2(0, -1).normalized()

func get_input(delta : float) -> void:

	if pilot != null:

		dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		if Input.is_action_pressed("ui_up"):
			if current_speed < MIN_VELOCITY:
				current_speed = MIN_VELOCITY
			else:
				current_speed = min(MAX_VELOCITY, current_speed + ACCELERATION * delta)
		elif Input.is_action_pressed("ui_down") && current_speed < min_velocity_to_stop:
					current_speed = max(MAX_VELOCITY_REVERSE, current_speed - ACCELERATION * delta)
		else:
			if abs(current_speed) > min_velocity_to_stop:
				current_speed *= 0.90
#				current_speed -= DESACCELERATION * sign(current_speed) * delta
	else:
		if abs(current_speed) > min_velocity_to_stop:
				current_speed *= 0.90

func _physics_process(delta):
	get_input(delta)

	if abs(current_speed) > min_velocity_to_stop:
		rotation_degrees += dir_rotation * (ANGULAR_VELOCITY + abs(current_speed) * 0.01) * delta
		check_animation(rotation_degrees)
		if $Anim.current_animation != "run":
			$Anim.play("run")
		else:
			$Anim.playback_speed = ANIM_SPEED_FACTOR * current_speed / MAX_VELOCITY
#	elif $Anim.current_animation != "Idle" or not $Anim.is_playing():
#		$Anim.playback_speed = 1
#		$Anim.play("Idle")

	move_and_slide(dir_move.rotated(deg2rad(rotation_degrees)) * current_speed * delta, Vector2())

func check_animation(rot_deg : float) -> void:
	if abs(rot_deg) < 0 + DEG_CHANGE_ANIM:
		base.animation = "run_up"
	elif abs(rot_deg) < 0 + DEG_CHANGE_ANIM * 2:
		base.animation = "run_up"
		base.flip_h = true if rot_deg < 0 else false
	elif abs(rot_deg) < 180 - DEG_CHANGE_ANIM * 2:
		base.animation = "run_side"
		base.flip_h = true if rot_deg < 0 else false
	elif abs(rot_deg) < 180 - DEG_CHANGE_ANIM:
		base.animation = "run_down"
		base.flip_h = true if rot_deg < 0 else false
	else:
		base.animation = "run_down"


	
	
