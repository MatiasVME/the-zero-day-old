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

const DEG_CHANGE_ANIM : float = 30.0
var min_velocity_to_stop : float = 1 + DESACCELERATION * ( 1.0 / 60.0 ) 
var dir_move : Vector2
var dir_rotation : float
var current_speed : float

# Cuando el boton enter es presionado
var input_action : bool = false

var player

onready var base : = $Base

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
		elif has_driver() and get_driver().can_move:
			.leave(get_driver())
	
#	print("has_driver(): ", has_driver())
#	if has_driver():
#		self.can_move = get_driver().can_move
#	else:
#		self.can_move = false
	
	if has_driver():
		$Pivot.aim(delta)
		$Pivot.set_cannon_sprite(DEG_CHANGE_ANIM)
		for p in drivers:
			p.position = $EnterArea/Collision.global_position
		
		dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		if Input.is_action_pressed("ui_up"):
			if current_speed < MIN_VELOCITY:
				current_speed = MIN_VELOCITY
			else:
				current_speed = min(MAX_VELOCITY, current_speed + ACCELERATION * delta)
		elif Input.is_action_pressed("ui_down") && current_speed < min_velocity_to_stop:
					current_speed = max(MAX_VELOCITY_REVERSE, current_speed - ACCELERATION * delta)
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
		check_animation(rotation_degrees)
		if $Anim.current_animation != "Foward":
			$Anim.play("Foward")
		else:
			$Anim.playback_speed = ANIM_SPEED_FACTOR * current_speed / MAX_VELOCITY
#	elif $Anim.current_animation != "Idle" or not $Anim.is_playing():
#		$Anim.playback_speed = 1
#		$Anim.play("Idle")
		
	move_and_slide(dir_move.rotated(deg2rad(rotation_degrees)) * current_speed * delta, Vector2())

func check_animation(rot_deg : float) -> void:
	if abs(rot_deg) < 0 + DEG_CHANGE_ANIM:
		base.animation = "foward_up"
	elif abs(rot_deg) < 0 + DEG_CHANGE_ANIM * 2:
		base.animation = "foward_side_up"
		base.flip_h = true if rot_deg < 0 else false
	elif abs(rot_deg) < 180 - DEG_CHANGE_ANIM * 2:
		base.animation = "foward_side"
		base.flip_h = true if rot_deg < 0 else false
	elif abs(rot_deg) < 180 - DEG_CHANGE_ANIM:
		base.animation = "foward_side_down"
		base.flip_h = true if rot_deg < 0 else false
	else:
		base.animation = "foward_down"


func _on_unmounted(who):
	who.position = get_exit_position()
	who.call_deferred("enable_player")
	CameraManager.current_camera.following = who

func _on_mounted(who):
	who.disable_player()
	who.can_move = true #Para probar en escena de test TTank
	CameraManager.current_camera.following = self
	# TODO: Casos en los cuales hay mas de un driver en el auto
	
func _on_EnterArea_body_entered(body):
	if not player and body is GPlayer:
		player = body
		
func _on_EnterArea_body_exited(body):
	if body is GPlayer and body == player:
		player = null

#TODO: Revisar (puede haber casos en que entre en un loop infinito
# o no se pocisione correctamente)
func get_exit_position() -> Vector2:
	var area_shape = $EnterArea/Collision.shape
	var pos : Vector2 = Vector2(0, area_shape.extents.y)

	var ray : = RayCast2D.new()
	ray.enabled = true
	ray.position = Vector2()
	self.add_child(ray)
	ray.cast_to = pos 
	ray.force_raycast_update()
	while ray.is_colliding():
		ray.cast_to = ray.cast_to.rotated(PI / 4)
		ray.force_raycast_update()
	pos = ray.cast_to.rotated(ray.global_rotation)
	ray.queue_free()

	return pos + global_position
	
	
	