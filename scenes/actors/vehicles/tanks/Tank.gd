extends Vehicle

class_name Tank

# Properties
export (float) var MAX_VELOCITY = 60
export (float) var MAX_VELOCITY_REVERSE = 30
export (float) var MIN_VELOCITY = 5
export (float) var ACCELERATION = 15
export (float) var DESACCELERATION = 60
export (float) var ANGULAR_VELOCITY = 20
export (float) var ANIM_SPEED_FACTOR = 5

const DEG_CHANGE_ANIM : float = 30.0
enum States {IDLE, MOVING, DESTROYING, DESTROYED}
var state : int = States.IDLE
var min_velocity_to_stop : float = DESACCELERATION * ( 1.0 / 60.0 ) 
var dir_move : float
var dir_rotation : float
var current_speed : float

# Cuando el boton enter es presionado
var input_action : bool = false

var player

onready var base : = $Base
onready var interact_area : = $EnterArea/Collision
onready var cannon : = $Pivot
onready var animation : = $Anim

func _ready():
	current_speed = 0
	connect("mounted", self, "_on_mounted")
	connect("unmounted", self, "_on_unmounted")


func get_input() -> void:
	input_action = Input.is_action_just_pressed("interact")
	
	if input_action and state != States.DESTROYING :
		if player and player == PlayerManager.get_current_player():
			if not .mount(player):
				# TODO: Caso en los cuales no pueda montar el vehiculo
				pass
		elif get_driver():
			.leave(get_driver())
		
	dir_rotation = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	dir_move = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))


func _physics_process(delta):

	get_input()
	check_state()
	
	if get_driver():
		cannon.aim(delta)
		cannon.set_cannon_sprite(DEG_CHANGE_ANIM)
		for p in drivers:
			p.position = global_position
	
		if dir_move == -1 :
			if current_speed < MIN_VELOCITY:
				current_speed = MIN_VELOCITY
			else:
				current_speed = min(MAX_VELOCITY, current_speed + ACCELERATION * delta)
		elif dir_move == 1 :
				current_speed = max(- MAX_VELOCITY_REVERSE, current_speed - ACCELERATION * delta)
		
		if abs(current_speed) > min_velocity_to_stop:
			rotation_degrees += dir_rotation * (ANGULAR_VELOCITY + abs(current_speed)) * delta
			check_animation(rotation_degrees)
			if change_state(States.MOVING):
				animation.play("Foward")
	
	if not get_driver() or dir_move == 0:
		current_speed -= sign(current_speed) * DESACCELERATION * delta
	
	if abs(current_speed) > min_velocity_to_stop:
		var body = move_and_collide(Vector2.UP.rotated(deg2rad(rotation_degrees)) * current_speed * delta, true)
		if body and body.collider.has_method("smash"):
			body.collider.smash()


func check_state() -> void:
	match state:
		States.IDLE:
			pass
			#TODO:Determinar cosas para este estado
		States.MOVING:
			animation.playback_speed = ANIM_SPEED_FACTOR * current_speed / MAX_VELOCITY
		States.DESTROYING:
			animation.playback_speed = 1
		States.DESTROYED:
			pass
			#TODO:Determinar cosas para este estado


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
	who.call_deferred("enable_interact")


func _on_mounted(who):
	who.call_deferred("disable_interact")
	# TODO: Casos en los cuales hay mas de un driver en el auto


func _on_EnterArea_body_entered(body):
	if not player and body is GPlayer:
		player = body
	if body is GBullet:
		damage(body.damage)
		body.dead()


func _on_EnterArea_body_exited(body):
	if body is GPlayer and body == player:
		player = null


#TODO: Revisar (puede haber casos en que entre en un loop infinito
# o no se pocisione correctamente)
func get_exit_position() -> Vector2:
	var area_shape = interact_area.shape
	var pos : Vector2 = Vector2(0, area_shape.extents.y + 5)

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


#TODO: Falta comprobar que pasa si hay un conductor dentro
func damage(mount : int = 1) -> void:
	HP -= mount
	if HP > 0 :
		var tween = Tween.new()
		self.add_child(tween)
		tween.interpolate_property(self, "modulate", Color.white, Color(5, 5, 5), 0.05, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")
		tween.interpolate_property(self, "modulate", Color(5, 5, 5), Color.white, 0.05, Tween.TRANS_ELASTIC, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		tween.queue_free()
	else:
		HP = 0
		if change_state(States.DESTROYING):
			interact_area.disabled = true
			while has_driver():
				.leave(get_driver())
			animation.play("Destroy")


#Máquina de estados
func change_state(new_state : int) -> bool:
	match new_state:
		States.IDLE:
			if state == States.MOVING:
				state = new_state
				return true
		States.MOVING:
			if state == States.IDLE:
				state = new_state
				return true
		States.DESTROYING:
			if state == States.IDLE or state == States.MOVING:
				state = new_state
				return true
		States.DESTROYED:
			if state == States.DESTROYING:
				state = new_state
				return true
	return false

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Destroy":
		if change_state(States.DESTROYED):
			queue_free()