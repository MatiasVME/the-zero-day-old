extends Node

class_name AI

var is_active = false

onready var actor = get_parent()

onready var navigator = actor.get_node("navigator") if actor.has_node("navigator") else null

var state : int = 0 setget set_state

var target_point := Vector2()

export var distance_to_end_move := 5.0

var random_walk_area_center := Vector2(150,100)
var random_walk_area_radius := 20.0

## RandomWalk Timer
var time_to_update_random_walk := 3.0
var time_to_update_random_walk_progress := 0.0
##

# True : termino de moverse
var move_state := true
var move_state_x := true
var move_state_y := true

# DetectArea
var detected_bodies := []
var last_body : GActor

## Señales

signal changed_state(old_state, new_state)

func _ready():
	if actor.has_node("DetectArea"):
		actor.get_node("DetectArea").connect("body_entered", self, "_on_DetectArea_body_entered")
		actor.get_node("DetectArea").connect("body_exited", self, "_on_DetectArea_body_exited")
	
func active(_active := true):
	is_active = _active

func set_state(_state):
	var old_state = state
	state = _state
	emit_signal("changed_state", old_state, state)

func random_walk(delta):
	
	if not move_state_x or not move_state_y:
		move_to_point(delta, target_point)
		
	else:
		actor._stop_handler(delta)
		
	if time_to_update_random_walk_progress < time_to_update_random_walk : 
		time_to_update_random_walk_progress += delta
	else:
		target_point.x = rand_range(random_walk_area_center.x - random_walk_area_radius, random_walk_area_center.x + random_walk_area_radius)
		target_point.y = rand_range(random_walk_area_center.y - random_walk_area_radius, random_walk_area_center.y + random_walk_area_radius)
		
		#(navigator as Navigator).update_path(target_point)
		
		time_to_update_random_walk_progress = 0.0
		move_state_x = false
		move_state_y = false

func random_walk2(delta):
	
	if not move_state and move_to_point(delta, target_point):
		move_state = true
	else:
		actor._stop_handler(delta)
		
	if time_to_update_random_walk_progress < time_to_update_random_walk : 
		time_to_update_random_walk_progress += delta
	else:
		target_point.x = rand_range(random_walk_area_center.x - random_walk_area_radius, random_walk_area_center.x + random_walk_area_radius)
		target_point.y = rand_range(random_walk_area_center.y - random_walk_area_radius, random_walk_area_center.y + random_walk_area_radius)
		
		#(navigator as Navigator).update_path(target_point)
		
		time_to_update_random_walk_progress = 0.0
		move_state = false

func move_to_point2(delta, point) -> bool:
	
	var AP = point - actor.position
	
	if AP.length() > distance_to_end_move:
		actor._move_handler(delta, AP, false)
		return false
	
	return true

func move_to_point(delta, point) -> bool:
	
	var AP = point - actor.position
	
	var move_vector = AP*Vector2(!move_state_x, !move_state_y)
	
	actor._move_handler(delta, move_vector, false)
	
	var NAP = point - actor.position
	
	if not move_state_x and sign(AP.x) != sign(NAP.x): move_state_x = true
	if not move_state_y and sign(AP.y) != sign(NAP.y): move_state_y = true
	
	if move_state_x and move_state_y : return true
	return false

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