# Aqui van las caracteristicas comunes a todos los enemigos.

extends KinematicBody2D

signal state_changed

enum STATE{SPAWN, SEEKER, STAND, RUN, ATTACK, DIED}

var state:int = 0
var current_state:int = 0

var objective:Vector2 = Vector2(1000, 1000) #Favor no cambiar valores

#VARIABLES DE STATE
export var hp:int
export var min_hp:int
export var atk:int
export var view_distance:float
export var attack_rangue:float

func _ready():
	pass

func _physics_process(delta):
	#Estas 4 lineas funcionan como seguro contra tontos.
	if current_state!=state:
		self.emit_signal("state_changed")
		current_state=state
	
	match state:
		STATE.SPAWN:
			_spawn()
		STATE.SEEKER:
			_seeker()
		STATE.STAND:
			_stand()
		STATE.RUN:
			_run()
		STATE.ATTACK:
			_attack()
		STATE.DIED:
			_died()

func change_state(state): #Esta funcion es una forma segura de cambiar entre estados.
	self.state=state
	self.current_state=state
	emit_signal("state_changed")

#CADA FUNCION FUNCIONA COMO UN NODO INTERCAMBIANDO EL ESTADO SEGUN LA ENTRADA
#SOBRESCRIBIR TRAS SER HEREDADA PARA AGREGAR FUNCIONALIDAD

func _spawn():
	change_state(STATE.STAND)

func _seeker():
	if get_global_transform().origin.distance_to(objective) > view_distance:
		change_state(STATE.STAND)
	elif get_global_transform().origin.distance_to(objective) < attack_rangue:
		change_state(STATE.ATTACK)
	elif hp <= min_hp:
		change_state(STATE.RUN)

func _stand():
	if get_global_transform().origin.distance_to(objective) < view_distance:
		change_state(STATE.SEEKER)

func _run():
	if hp > min_hp:
		change_state(STATE.STAND)

func _attack():
	if get_global_transform().origin.distance_to(objective) < attack_rangue:
		change_state(STATE.SEEKER)

func _died():
	pass