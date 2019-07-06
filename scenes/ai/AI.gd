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

export var distance_to_end_move := 7.0

var random_walk_area_center := Vector2(150,100)
var random_walk_area_radius := 50.0

## RandomWalk Timer
var time_to_update_random_walk := 6.0
var time_to_update_random_walk_progress := 0.0
##

# DetectArea
var detected_bodies := []
var last_body : GActor

## Señales

signal changed_state(old_state, new_state)

func _ready():
	
	var v1 = Vector2(1,0)
	var v2 = Vector2(0,-10)
	print(v2.angle_to(v1))
	
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
	
	if move_to(delta, target_point):
		actor._stop_handler(delta)
	
	if time_to_update_random_walk_progress < time_to_update_random_walk : 
		time_to_update_random_walk_progress += delta
		
	else:
		target_point.x = rand_range(random_walk_area_center.x - random_walk_area_radius, random_walk_area_center.x + random_walk_area_radius)
		target_point.y = rand_range(random_walk_area_center.y - random_walk_area_radius, random_walk_area_center.y + random_walk_area_radius)
		
		#(navigator as Navigator).update_path(target_point)
		
		time_to_update_random_walk_progress = 0.0
		

func move_to(delta, point) -> bool:
	
	if has_navigator:
		
		if time_update_navigator_progress >= time_update_navigator:
			navigator.update_path(point)
			time_update_navigator_progress = 0
		
		time_update_navigator_progress += delta
		actor.get_node("Navigator/Point").global_position = navigator.get_current_point()
		if move_to_point(delta, navigator.get_current_point()):
			navigator.next_index()
			if navigator.compare_points(actor.position):
				navigator.next_index()
			if navigator.out_of_index:
				return true
	else:
		print("No nav")
		if move_to_point(delta, point):
			return true
	return false
	
	

func move_to_point(delta, point) -> bool:
	
	var left_distance = point - actor.position
	
	if left_distance.length() > distance_to_end_move:
		actor._move_handler(delta, left_distance, false)
		return false
	
	return true

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