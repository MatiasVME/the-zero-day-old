extends Node

class_name AI

var is_active = false

onready var actor = get_parent()


var navigator : Navigator
var has_navigator := false
var time_update_navigator := 3.0
var time_update_navigator_progress := 0.0

var state : int = 0 setget set_state

var target_point := Vector2()

export var distance_to_end_move := 2.0

var random_walk_area_center := Vector2(150,100)
var random_walk_area_radius := 50.0

## RandomWalk Timer
var time_to_update_random_walk := 5.0
var time_to_update_random_walk_progress := 0.0
##
# True : moviendose
var is_moving := false setget set_moving
var is_moving_x := false setget set_moving_x
var is_moving_y := false setget set_moving_y

# DetectArea
var detected_bodies := []
var last_body : GActor

## Señales

signal changed_state(old_state, new_state)

func _ready():
	if actor.has_node("DetectArea"):
		actor.get_node("DetectArea").connect("body_entered", self, "_on_DetectArea_body_entered")
		actor.get_node("DetectArea").connect("body_exited", self, "_on_DetectArea_body_exited")
	if actor.has_node("Navigator"):
		navigator = actor.get_node("Navigator")
		has_navigator = true
	
func active(_active := true):
	is_active = _active

func set_state(_state):
	var old_state = state
	state = _state
	emit_signal("changed_state", old_state, state)

func random_walk(delta):
	
	if is_moving_xoy():
		move_to(delta, target_point)
		
	else:
		actor._stop_handler(delta)
		
	if time_to_update_random_walk_progress < time_to_update_random_walk : 
		time_to_update_random_walk_progress += delta
	else:
		target_point.x = rand_range(random_walk_area_center.x - random_walk_area_radius, random_walk_area_center.x + random_walk_area_radius)
		target_point.y = rand_range(random_walk_area_center.y - random_walk_area_radius, random_walk_area_center.y + random_walk_area_radius)
		
		#(navigator as Navigator).update_path(target_point)
		
		time_to_update_random_walk_progress = 0.0
		is_moving_x = true
		is_moving_y = true

func random_walk2(delta):
	
	if is_moving and move_to(delta, target_point):
		is_moving = false
	else:
		actor._stop_handler(delta)
		
	if time_to_update_random_walk_progress < time_to_update_random_walk : 
		time_to_update_random_walk_progress += delta
	else:
		target_point.x = rand_range(random_walk_area_center.x - random_walk_area_radius, random_walk_area_center.x + random_walk_area_radius)
		target_point.y = rand_range(random_walk_area_center.y - random_walk_area_radius, random_walk_area_center.y + random_walk_area_radius)
		
		#(navigator as Navigator).update_path(target_point)
		
		time_to_update_random_walk_progress = 0.0
		is_moving = true

func move_to(delta, point) -> bool:
	
	if has_navigator:
		if time_update_navigator_progress >= time_update_navigator:
			navigator.update_path(point)
			time_update_navigator_progress = 0
		else:
			time_update_navigator_progress += delta
			if move_to_point_circle(delta, navigator.get_current_point()):
				navigator.next_index()
				if navigator.out_of_index:
					set_moving(false)
					return true
		
	else:
		if move_to_point_circle(delta, point):
			set_moving(false)
			return true
	return false
	
	

func move_to_point_circle(delta, point) -> bool:
	
	var AP = point - actor.position
	
	if AP.length() > distance_to_end_move:
		actor._move_handler(delta, AP, false)
		return false
	
	return true

# Cuando termina de moverse retorna true
func move_to_point_square(delta, point) -> bool:
	
	var AP = point - actor.position
	
	var move_vector = AP*Vector2(is_moving_x, is_moving_y)
	
	actor._move_handler(delta, move_vector, false)
	
	var NAP = point - actor.position
	
	if is_moving_x and sign(AP.x) != sign(NAP.x): is_moving_x = false
	if is_moving_y and sign(AP.y) != sign(NAP.y): is_moving_y = false
	
	if not is_moving_xoy() : return true
	return false

func is_moving_xoy():
	return is_moving_x or is_moving_y

func set_moving(_is_moving):
	is_moving = _is_moving
	is_moving_x = _is_moving
	is_moving_y = _is_moving

func set_moving_x(_is_moving_x):
	is_moving_x = _is_moving_x
	is_moving = is_moving_x and is_moving_y

func set_moving_y(_is_moving_y):
	is_moving_y = _is_moving_y
	is_moving = is_moving_y and is_moving_x


func _on_DetectArea_body_entered(body : PhysicsBody2D):
	if not is_active : return
	if body is GActor:
		actor_entered(body)

func _on_DetectArea_body_exited(body : PhysicsBody2D):
	if not is_active : return
	if body is GActor:
		actor_exited(body)


# warning-ignore:unused_argument
func actor_entered(body) -> void:
	pass
# warning-ignore:unused_argument
func actor_exited(body) -> void:
	pass