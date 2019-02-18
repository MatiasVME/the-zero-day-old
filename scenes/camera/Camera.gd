extends Camera2D

var following

enum Mode {FOLLOW, FREE}
var mode = Mode.FOLLOW

var input_dir : Vector2

func _physics_process(delta):
	if mode == Mode.FOLLOW and following:
		global_position = following.global_position
	elif mode == Mode.FREE:
		input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
		if input_dir.x == 1:
			global_position.x += 500 * delta
		elif input_dir.x == - 1:
			global_position.x -= 500 * delta
		
		if input_dir.y == 1:
			global_position.y += 500 * delta
		elif input_dir.y == - 1:
			global_position.y -= 500 * delta
			
		