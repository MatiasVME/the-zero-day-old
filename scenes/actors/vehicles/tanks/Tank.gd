extends Vehicle

class_name Tank

# Properties
export (float) var MAX_VELOCITY = 4000
export (float) var MAX_VELOCITY_REVERSE = -1000
export (float) var MIN_VELOCITY = 200
export (float) var ACCELERATION = 1000
export (float) var DESACCELERATION = 170
export (float) var ANGULAR_VELOCITY = 20
export (float) var ANIM_SPEED_FACTOR = 5

var min_velocity_to_stop : float = 1 + DESACCELERATION * ( 1.0 / 60.0 ) 
var dir_move : Vector2
var dir_rotation : float
var current_speed : float

# Cuando el boton enter es presionado
var input_action : bool = false

var player

func _ready():
	current_speed = 0
	dir_move = Vector2(0, -1).normalized()
	
	connect("mounted", self, "_on_mounted")
	connect("unmounted", self, "_on_unmounted")

func get_input(delta : float) -> void:
	input_action = Input.is_action_just_pressed("ui_accept")
	
	if input_action:	
		if player and player.can_move:
			if not .mount(player):
				# TODO: Caso en los cuales no pueda montar el vehiculo
				pass
		elif has_driver() and self.can_move:
			.leave(get_driver())
	
#	print("has_driver(): ", has_driver())
#	if has_driver():
#		self.can_move = get_driver().can_move
#	else:
#		self.can_move = false
	
	if has_driver():
		$Pivot.aim(delta)
		
		for p in drivers:
			p.position = $EnterArea/Collision.global_position
		
		dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		if Input.is_action_pressed("ui_up"):
			if current_speed < MIN_VELOCITY:
				current_speed = MIN_VELOCITY
			if current_speed < MAX_VELOCITY:
				current_speed += ACCELERATION * delta
			else:
				current_speed = MAX_VELOCITY
		elif Input.is_action_pressed("ui_down") && current_speed < min_velocity_to_stop:
				if current_speed > MAX_VELOCITY_REVERSE:
					current_speed += - ACCELERATION * delta
				else:
					current_speed = MAX_VELOCITY_REVERSE
		else:
			if abs(current_speed) > min_velocity_to_stop:
				current_speed *= 0.90
#				current_speed -= DESACCELERATION * sign(current_speed) * delta
	else:
		if abs(current_speed) > min_velocity_to_stop:
				current_speed *= 0.90

func _physics_process(delta):
	get_input(delta)
	
	if abs(current_speed) > min_velocity_to_stop:
		rotation_degrees += dir_rotation * (ANGULAR_VELOCITY + abs(current_speed) * 0.01) * delta
		if $Anim.current_animation != "Foward":
			$Anim.play("Foward")
		else:
			$Anim.playback_speed = ANIM_SPEED_FACTOR * current_speed / MAX_VELOCITY
	elif $Anim.current_animation != "Idle" or not $Anim.is_playing():
		$Anim.playback_speed = 1
		$Anim.play("Idle")
		
	move_and_slide(dir_move.rotated(deg2rad(rotation_degrees)) * current_speed * delta, Vector2())

func _on_unmounted(who):
	who.position = $EnterArea/Collision.global_position
	who.enable_player()

func _on_mounted(player):
	player.disable_player()
	# TODO: Casos en los cuales hay mas de un driver en el auto

func _on_EnterArea_body_entered(body):
	if not player and body is GPlayer:
		player = body
		
func _on_EnterArea_body_exited(body):
	if body is GPlayer and body == player:
		player = null
