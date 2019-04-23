extends Node

class_name AI

var is_active = false

onready var actor = get_parent()

onready var navigator = actor.get_node("navigator") if actor.has_node("navigator") else null

var state : int = 0 setget set_state

var target_point := Vector2()

var random_walk_area_center := Vector2()
var random_walk_area_radius := 15.0

## RandomWalk Timer
var time_to_update_random_walk := 3.0
var time_to_update_random_walk_progress := 0.0
##

# True : termino de moverse
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
	emit_signal("changed_state", state, _state)
	state = _state

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
	if body is GActor:
		detected_bodies.append(body)

func _on_DetectArea_body_exited(body : PhysicsBody2D):
	if body is GActor:
		var i = detected_bodies.find(body)
		if i != -1 : detected_bodies.remove(i)