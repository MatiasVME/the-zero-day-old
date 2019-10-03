# Aqui van las caracteristicas comunes a todos los enemigos.

extends "res://scenes/actors/GActor.gd"

class_name GEnemy

var damage_label = preload("res://scenes/hud/floating_hud/FloatingText.tscn")

enum State {
	STAND,
	SEEKER,
	RUN,
	ATTACK,
	DIE,
	RANDOM_WALK,
	STUNNED
}
var state : int = 0
var current_state : int = 0

# Puede recibir daño ?
var can_damage = false

# Contine el TZDCharacter con todos los datos
# y eventos que invulucra
var data

signal state_changed

func _init():
	data = TZDCharacter.new()

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
	if not can_damage:
		return
	
	.damage(amount)
	
	if $Anim.has_animation("damage") and not $Anim.is_playing():
		$Anim.play("damage")
	
	data.damage(amount)
	
	# Instancia un label indicando el daño recibido y lo agrega al árbol
	var dmg_label : FloatingText = damage_label.instance()
	dmg_label.init(amount, FloatingText.Type.DAMAGE)
	dmg_label.position = global_position
	get_parent().add_child(dmg_label)
	
	can_damage = false
	$DamageDelay.start()

func knockback(distance : Vector2):
	pass

# Golpe al jugador
func hit():
	pass

func spawn():
	if $Anim.has_animation("spawn"):
		$Anim.play("spawn")

func dead():
	$Collision.disabled = true
	
	if $Anim.has_animation("dead"):
		$Anim.play("dead")

func _on_DamageDelay_timeout():
	can_damage = true

func _on_Anim_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()

func _on_GEnemy_mouse_entered():
	CursorManager.change_cursor(CursorManager.Cursor.POINTING)

func _on_GEnemy_mouse_exited():
	CursorManager.change_cursor(CursorManager.Cursor.IDLE)
