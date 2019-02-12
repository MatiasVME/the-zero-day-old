extends "res://scenes/actors/vehicles/Vehicle.gd"

# Properties
export (float) var MAX_VELOCITY = 4000
export (float) var MAX_VELOCITY_REVERSE = -1000
export (float) var MIN_VELOCITY = 200
export (float) var ACCELERATION = 1000
export (float) var DESACCELERATION = 170
export (float) var ANGULAR_VELOCITY = 20

var min_velocity_to_stop : float = 1 + DESACCELERATION * ( 1.0 / 60.0 ) 
var dir_move : Vector2
var dir_rotation : float
var current_speed : float

# Cuando el boton enter es presionado
var input_action : bool = false
# Cuando puede hacer la accion de entrar al vehiculo
# esto evita que entre y salga rapidamente
# (No se me a ocurrido una mejor solucion por ahora)
var can_action : bool = true

var player

func _ready():
	current_speed = 0
	dir_move = Vector2(0, -1).normalized()
	
	connect("mounted", self, "_on_mounted")
	connect("unmounted", self, "_on_unmounted")

func _get_input(delta : float) -> void:
	if self.can_move:
		$Pivot.aim(delta)
		
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
	input_action = Input.is_action_pressed("ui_accept")
	
	if can_action:
		if player and input_action and not can_move:
			print("OK")
			if not .mount(player):
				# TODO: Caso en los cuales no pueda montar el vehiculo
				pass
			else:
				can_action = false
		elif drivers.size() > 0 and input_action and can_move:
			print("OK3")
			.leave(player)
			can_action = false
		
	if not can_move:
		return
	
	_get_input(delta)
	if abs(current_speed) > min_velocity_to_stop:
		rotation_degrees += dir_rotation * (ANGULAR_VELOCITY + abs(current_speed) * 0.01) * delta
		if $Anim.current_animation != "Foward":
			$Anim.play("Foward")
		else:
			$Anim.playback_speed = sign(current_speed) * 1 + current_speed / MAX_VELOCITY
	elif $Anim.current_animation != "Idle" or not $Anim.is_playing():
		$Anim.playback_speed = 1
		$Anim.play("Idle")
	move_and_slide(dir_move.rotated(deg2rad(rotation_degrees)) * current_speed * delta, Vector2())

func _on_unmounted(who):
	who.enable_player()
	who.position = position
	who.position.x += 20
	who.position.y += 10
	
	self.can_move = false

func _on_mounted(player):
	if drivers.size() == 1:
		print(player)
		player.disable_player()
		self.can_move = true
	# TODO: Casos en los cuales hay mas de un driver en el auto

func _on_EnterArea_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		
func _on_EnterArea_body_exited(body):
	if not can_move and body.is_in_group("Player"):
		player = null

func _on_Timer_timeout():
	can_action = true
