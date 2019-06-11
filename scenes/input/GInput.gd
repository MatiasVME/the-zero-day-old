extends Node

class_name GInput

onready var actor = get_parent()
onready var analog = get_tree().get_nodes_in_group("Analog")

var is_active := false

var input_dir := Vector2()
var input_run := false

func _ready():
	if actor is GActor:
		active()
	
	if analog.size() > 0:
		analog = analog[0]
		analog.connect("current_force_updated", self, "_on_current_force_updated")

func _physics_process(delta):
	if not is_active or actor.is_disabled : return
	
	if actor.can_move:
		if not Main.is_mobile:
			input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
			input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
			input_run = Input.is_action_pressed("run")
		else:
			input_run = true
			
		if input_dir == Vector2():
			actor._stop_handler(delta)
		else:
			actor._move_handler(delta, input_dir, input_run)
	
	if not Main.is_mobile and Input.is_action_pressed("fire"):
		actor._fire_handler()
	
	if not Main.is_mobile and Input.is_action_just_pressed("reload"):
		actor._reload_handler()
	
func active(_active := true):
	is_active = _active

func _on_current_force_updated(force):
	input_dir.x = force.x
	input_dir.y = -force.y