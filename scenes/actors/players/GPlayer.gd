extends KinematicBody2D

export (int) var speed = 2000

var move_x
var move_y

puppet var p_move_x = 0
puppet var p_move_y = 0

var input_dir : Vector2 = Vector2()
var input_run : bool = false

func _ready():
	pass

func _physics_process(delta):
	if not Networking.multiplayer_on or is_network_master():
		input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		input_run = Input.is_action_pressed("run")
		
		if not input_run:
			move_x = input_dir.x * speed * delta
			move_y = input_dir.y * speed * delta
			$Sprite.speed_scale = 0.6
		else:
			move_x = input_dir.x * speed * 2 * delta
			move_y = input_dir.y * speed * 2 * delta
			$Sprite.speed_scale = 1.2
		
		if input_dir.x == -1 and input_dir.y == 0:
			$Anim.play("MoveSide")
			$Sprite.flip_h = true
		elif input_dir.x == -1 and input_dir.y == -1:
			$Anim.play("MoveUp")
		elif input_dir.x == 0 and input_dir.y == -1:
			$Anim.play("MoveUp")
		elif input_dir.x == 1 and input_dir.y == -1:
			$Anim.play("MoveUp")
		elif input_dir.x == 1 and input_dir.y == 0:
			$Anim.play("MoveSide")
			$Sprite.flip_h = false
		elif input_dir.x == 1 and input_dir.y == 1:
			$Anim.play("MoveDown")
			$Sprite.flip_h = false
		elif input_dir.x == 0 and input_dir.y == 1:
			$Anim.play("MoveDown")
			$Sprite.flip_h = false
		elif input_dir.x == -1 and input_dir.y == 1:
			$Anim.play("MoveDown")
			$Sprite.flip_h = false
		else:
			if $Anim.current_animation != "Idle" or not $Anim.is_playing():
				$Anim.play("Idle")
				$Sprite.speed_scale = 0.1
		
		if move_x != 0 and move_y != 0:
			move_x /= 1.5
			move_y /= 1.5
		
		if Networking.multiplayer_on:
			rset_unreliable("p_move_x", move_x)
			rset_unreliable("p_move_y", move_y)
	
	else:
		move_x = p_move_x
		move_y = p_move_y
	
	move_and_slide(Vector2(move_x, move_y), Vector2())
	
	
	
	