extends Camera2D

const SPEED = 150

var following setget set_following, get_following

enum Mode {FOLLOW, FREE}
var mode = Mode.FOLLOW setget set_mode

var input_dir : Vector2
var input_change_focus : bool

var objective_pos
var clamp_vector := 30.0

func _ready():
	PlayerManager.connect("player_shooting", self, "_on_player_shooting")
	
func _physics_process(delta):
	if not is_instance_valid(following):
		return
		
	input_change_focus = Input.is_action_just_pressed("change_focus")
	
	if input_change_focus:
		change_focus()

	if mode == Mode.FOLLOW:
		if following and not following.is_disabled:
			if not Main.is_mobile:
				objective_pos = get_global_mouse_position()
				global_position = following.global_position + (((following.global_position + objective_pos) / 2) - following.global_position).clamped(clamp_vector)
			elif following.selected_num == -1:
				$MobileSelected.hide()
				global_position = following.global_position
			else:
				objective_pos = following.selected_enemy.global_position
				$MobileSelected.show()
				$MobileSelected.global_position = objective_pos
				global_position = following.global_position + (((following.global_position + objective_pos) / 2) - following.global_position).clamped(clamp_vector)
		else:
			mode = Mode.FREE
	elif mode == Mode.FREE:
		input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
		if input_dir.x == 1:
			global_position.x += SPEED * delta
		elif input_dir.x == - 1:
			global_position.x -= SPEED * delta
		
		if input_dir.y == 1:
			global_position.y += SPEED * delta
		elif input_dir.y == - 1:
			global_position.y -= SPEED * delta
	
func set_following(_following : GActor):
	following = _following
	
func get_following():
	return following
	
func set_mode(_mode):
	mode = _mode

func change_focus():
	following.can_move = false
	following = PlayerManager.get_next_player()
	following.can_move = true

func _on_player_shooting(player, dir):
	$Anim.play("fire")