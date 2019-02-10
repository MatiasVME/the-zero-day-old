extends "res://scenes/actors/vehicles/Vehicle.gd"
#Signals

#Properties
export (float) var MAX_VELOCITY = 800
export (float) var MIN_VELOCITY = -400
export (float) var ACCELERATION = 180
export (float) var DESACCELERATION = 170
export (float) var ANGULAR_VELOCITY = 20
export (float) var CANNON_ANGULAR_VELOCITY = 50
var dir_move : Vector2
var dir_rotation : float
var current_speed : float

func _ready():
	current_speed = 0
	dir_move = Vector2(0, -1).normalized()

func _move(delta : float) -> void:
	dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if Input.is_action_pressed("ui_up"):
		if current_speed < MAX_VELOCITY:
			current_speed += ACCELERATION * delta
		else:
			current_speed = MAX_VELOCITY
	elif Input.is_action_pressed("ui_down"):
			if current_speed > MIN_VELOCITY:
				current_speed += - ACCELERATION * delta
			else:
				current_speed = MIN_VELOCITY
	else:
		if abs(current_speed) > 0.5:
			current_speed -= DESACCELERATION * sign(current_speed) * delta

func _physics_process(delta):
	_move(delta)
	if abs(current_speed) > 10:
		rotation_degrees += dir_rotation * ANGULAR_VELOCITY * delta
	move_and_slide(dir_move.rotated(deg2rad(rotation_degrees)) * current_speed * delta, Vector2())