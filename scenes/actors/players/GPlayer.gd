extends KinematicBody2D

class_name GPlayer

# Es la data del player y la logica del mismo
var data : PHCharacter

export (int) var speed = 2500

var move_x
var move_y

var input_dir : Vector2 = Vector2()
var input_run : bool = false

var can_move : bool = false

func _physics_process(delta):
	if not can_move:
		return
		
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
		
	move_and_slide(Vector2(move_x, move_y), Vector2())
	
func disable_player():
	visible = false
	$Collision.disabled = true
	can_move = false
	
func enable_player():
	visible = true
	can_move = true
	$Collision.disabled = false

func _on_GetArea_body_entered(body):
	if body is ItemInWorld:
		body.queue_free()
