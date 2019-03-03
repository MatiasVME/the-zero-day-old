# Aqui van las caracteristicas comunes a todos los enemigos.

extends "res://scenes/actors/GActor.gd"

signal state_changed

enum State {
	STAND,
	SEEKER,
	RUN,
	ATTACK,
	DIE,
	RANDOM_WALK
}
var state : int = 0
var current_state : int = 0

# Puede recibir daño ?
var can_damage = false

# Contine el PHCharacter con todos los datos
# y eventos que invulucra
var data

func _init():
	data = PHCharacter.new()

func _physics_process(delta):
	# Estas 4 lineas funcionan como seguro contra tontos.
	if current_state != state:
		self.emit_signal("state_changed")
		current_state = state

# Esta funcion es una forma segura de cambiar entre estados.
func change_state(state): 
	self.state = state
	self.current_state = state
	emit_signal("state_changed")

# Todos los enemigos tienen estos metodos como minimo
#

func damage(amount):
	can_damage = false
	
	if $Anim.has_animation("damage"):
		$Anim.play("damage")

# Golpe al jugador
func hit():
	pass

func spawn():
	if $Anim.has_animation("spawn"):
		$Anim.play("spawn")

func dead():
	if $Anim.has_animation("dead"):
		$Anim.play("dead")

func _on_DamageDelay_timeout():
	can_damage = true

func _on_Anim_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()

