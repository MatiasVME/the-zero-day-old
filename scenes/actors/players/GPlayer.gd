extends KinematicBody2D

export (int) var speed = 3000

var move_x
var move_y

var input_dir : Vector2 = Vector2()

var dir_x = 0
var dir_y = 0

func _ready():
	pass

func _physics_process(delta):
	input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	move_x = input_dir.x * speed * delta
	move_y = input_dir.y * speed * delta
	
	if input_dir.x == -1 and input_dir.y == 0:
		$Anim.play("RunSide")
		$Sprite.flip_h = true
	elif input_dir.x == -1 and input_dir.y == -1:
		$Anim.play("RunUp")
	elif input_dir.x == 0 and input_dir.y == -1:
		$Anim.play("RunUp")
	elif input_dir.x == 1 and input_dir.y == -1:
		$Anim.play("RunUp")
	elif input_dir.x == 1 and input_dir.y == 0:
		$Anim.play("RunSide")
		$Sprite.flip_h = false
	elif input_dir.x == 1 and input_dir.y == 1:
		$Anim.play("RunDown")
		$Sprite.flip_h = false
	elif input_dir.x == 0 and input_dir.y == 1:
		$Anim.play("RunDown")
		$Sprite.flip_h = false
	elif input_dir.x == -1 and input_dir.y == 1:
		$Anim.play("RunDown")
		$Sprite.flip_h = false
	else:
		if $Anim.current_animation != "Idle" or not $Anim.is_playing():
			$Anim.play("Idle")
	
	if move_x != 0 and move_y != 0:
		move_x /= 1.5
		move_y /= 1.5
	
	move_and_slide(Vector2(move_x, move_y), Vector2())
	
	
	
	