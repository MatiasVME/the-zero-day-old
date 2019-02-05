extends KinematicBody2D

export (int) var speed = 5000
#export (int) var max_speed = 5000
#export (int) var acel = 4500
#export (int) var decel = 6500

var move_x
var move_y

var input_dir_x = 0
var input_dir_y = 0

var dir_x = 0
var dir_y = 0

#enum MoveTo {
#	IDLE = -1
#	LEFT, 
#	LEFT_UP, 
#	UP, 
#	UP_RIGHT, 
#	RIGHT, 
#	RIGHT_DOWN, 
#	DOWN, 
#	DOWN_LEFT
#}
#var move_to = MoveTo.IDLE

func _ready():
	pass

func _physics_process(delta):
	input_dir_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_dir_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	move_x = input_dir_x * speed * delta
	move_y = input_dir_y * speed * delta
	
	move_and_slide(Vector2(move_x, move_y), Vector2())
	
	
#	if input_dir_x:
#		dir_x = input_dir_x
#	if input_dir_y:
#		dir_y = input_dir_y
#
#	input_dir_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
#	input_dir_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
#
#	if input_dir_x == - dir_x:
#		speed_x /= 3
#	if input_dir_y == - dir_y:
#		speed_y /= 3
#
#	if input_dir_x:
#		speed_x += acel * delta
#	else:
#		speed_x -= decel * delta
#	if input_dir_y:
#		speed_y += acel * delta
#	else:
#		speed_y -= decel * delta
#
#	speed_x = clamp(speed_x, 0, max_speed)
#	move_x = speed_x * delta * dir_x
#	speed_y = clamp(speed_y, 0, max_speed)
#	move_y = speed_y * delta * dir_y
#
#	print(move_x, "-", move_y)
#	move_and_slide(Vector2(move_x, move_y), Vector2())
	
	
	
	
	
	
	