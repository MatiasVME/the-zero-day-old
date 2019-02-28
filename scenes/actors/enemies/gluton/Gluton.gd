# Aqui van las caracteristicas del enemigo Gluton

extends "res://scenes/actors/enemies/GEnemy.gd"

var hp:int = 10
var speed:int = 2
var attack:int = 2

var view_distance:float = 10
var attack_distance:float = 1

onready var objective = 0

func _ready():
	self.state = 0

func _process(delta):
	pass

func _physics_process(delta):
	if objective:
		match state:
			0: #STAND
				$Body.play("Idle")
				if self.get_global_position().distance_to(objective.get_global_position()) < 100:
					change_state(1)
				if self.hp < 3:
					change_state(2)
			1: #SEEKER
				sekeer(objective)
				if self.get_global_position().distance_to(objective.get_global_position()) > 100 and objective as GPlayer:
					change_state(0)
					"""
				if self.get_global_position().distance_to(objective) < 20:
					change_state(3)
					"""
				if self.hp < 3:
					change_state(2)
			2: #RUN
				run(objective)
				if self.hp > 3:
					change_state(0)
			3: #ATTACK
				objective.damage(10)
				if self.get_global_position().distance_to(objective.get_global_position()) > 20:
					change_state(1)
				if self.hp < 3:
					change_state(2)
			4: #DIE
				self.queue_free()

func get_direction_to_see(objective): #Devuelve la direccion en grados
	if round(transform.origin.angle_to_point(objective.get_global_position())) == 2:
		return 0
	elif round(transform.origin.angle_to_point(objective.get_global_position())) == -2:
		return 180
	elif round(transform.origin.angle_to_point(objective.get_global_position())) == 0:
		return -90
	elif round(transform.origin.angle_to_point(objective.get_global_position())) == 3:
		return 90
	else:
		return $Body.get_animation()

func sekeer(objective): #Rutina en caso de que vea al objetivo
	match get_direction_to_see(objective):
		0:
			$Body.play("Run_Up")
			self.move_and_slide(Vector2(0, -10))
		180:
			$Body.play("Run_Down")
			self.move_and_slide(Vector2(0, 10))
		90:
			if $Body.flip_h:
				$Body.flip_h = false
			$Body.play("Run_Side")
			self.move_and_slide(Vector2(10, 0))
		-90:
			if !$Body.flip_h:
				$Body.flip_h = true
			$Body.play("Run_Side")
			self.move_and_slide(Vector2(-10, 0))

func run(objective): #Rutina en caso de tener que huir del objetivo
	match get_direction_to_see(objective):
		0:
			$Body.play("Run_Down")
			self.move_and_slide(Vector2(0, 10))
			
		180:
			$Body.play("Run_Up")
			self.move_and_slide(Vector2(0, -10))
		90:
			if !$Body.flip_h:
				$Body.flip_h = true
			$Body.play("Run_Side")
			self.move_and_slide(Vector2(-10, 0))
		-90:
			if $Body.flip_h:
				$Body.flip_h = false
			$Body.play("Run_Side")
			self.move_and_slide(Vector2(10, 0))

func _on_Area2D_body_entered(body):
	if body as GPlayer:
		objective = body


func _on_Area2D_body_exited(body):
	if body as GPlayer:
		objective = 0
