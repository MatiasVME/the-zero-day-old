# Aqui van las caracteristicas comunes a todos los enemigos.

extends KinematicBody2D

signal state_changed

var state:int = 0
var current_state:int = 0

func _ready():
	pass


func _physics_process(delta):
	#Estas 4 lineas funcionan como seguro contra tontos.
	if current_state != state:
		self.emit_signal("state_changed")
		current_state=state


func change_state(state): #Esta funcion es una forma segura de cambiar entre estados.
	self.state = state
	self.current_state = state
	emit_signal("state_changed")