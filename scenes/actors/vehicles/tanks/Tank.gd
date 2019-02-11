extends "res://scenes/actors/vehicles/Vehicle.gd"
#Signals

#Properties
export (float) var MAX_VELOCITY = 800
export (float) var MAX_VELOCITY_REVERSE = -400
export (float) var MIN_VELOCITY = 50
export (float) var ACCELERATION = 180
export (float) var DESACCELERATION = 170
export (float) var ANGULAR_VELOCITY = 20
var min_velocity_to_stop : float = 1 + DESACCELERATION * ( 1.0 / 60.0 ) 
var dir_move : Vector2
var dir_rotation : float
var current_speed : float

func _ready():
	current_speed = 0
	dir_move = Vector2(0, -1).normalized()

func _move(delta : float) -> void:
	dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if Input.is_action_pressed("ui_up"):
		if current_speed < MIN_VELOCITY:
			current_speed = MIN_VELOCITY
		if current_speed < MAX_VELOCITY:
			current_speed += ACCELERATION * delta
		else:
			current_speed = MAX_VELOCITY
	elif Input.is_action_pressed("ui_down") && current_speed < min_velocity_to_stop:
			if current_speed > MAX_VELOCITY_REVERSE:
				current_speed += - ACCELERATION * delta
			else:
				current_speed = MAX_VELOCITY_REVERSE
	else:
		if abs(current_speed) > min_velocity_to_stop:
			current_speed *= 0.90
#			current_speed -= DESACCELERATION * sign(current_speed) * delta

func _physics_process(delta):
	_move(delta)
	if abs(current_speed) > 10:
		rotation_degrees += dir_rotation * (ANGULAR_VELOCITY + abs(current_speed) * 0.01) * delta
		if $Anim.current_animation != "Foward":
			$Anim.play("Foward")
		else:
			$Anim.playback_speed = sign(current_speed) * 1 + current_speed / MAX_VELOCITY
	elif $Anim.current_animation != "Idle" or not $Anim.is_playing():
		$Anim.playback_speed = 1
		$Anim.play("Idle")
	move_and_slide(dir_move.rotated(deg2rad(rotation_degrees)) * current_speed * delta, Vector2())