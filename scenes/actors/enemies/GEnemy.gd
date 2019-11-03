"""
	GEnemy: Aqui van las caracteristicas comunes a todos los enemigos.
	
	Las animaciónes comúnes que pueden tener los enemigos son:
		- Idle
		- Run
		- Dead
		- Attack
		- Damage
	
	Ese nombre deben respetar los hijos de GEnemy.tscn y GEnemy.gd.
"""

extends "res://scenes/actors/GActor.gd"

class_name GEnemy

var damage_indicator_label = preload("res://scenes/hud/floating_hud/FloatingText.tscn")

# Debe tener esta variable para que la camara pueda seguir a este
# enemigo. Ya que los GPlayer tienen esta variable.
# NEEDFIX
var selected_num := -1 # -1 es nignuno seleccionado

enum State {
	STAND,
	SEEKER,
	RUN,
	ATTACK,
	DIE,
	RANDOM_WALK,
	STUNNED
}
var state := 0
var current_state := 0

# Puede recibir daño ?
var can_damage = true

# Contine el TZDEnemy con todos los datos
# y eventos que invulucra
var data : TZDEnemy

signal state_changed

func _init():
	data = TZDEnemy.new()
	
func _ready():
	data.connect("dead", self, "_on_dead")

# Esta funcion es una forma segura de cambiar entre estados.
func change_state(_state): 
	if current_state != _state:
		state = _state
		current_state = _state
		emit_signal("state_changed")

# Todos los enemigos tienen estos metodos como minimo
#

func damage(amount, who = null):
	if not can_damage:
		return

	$Anims/Damage.play("Damage")
	
	data.damage(amount)
	show_damage_indicator("-" + str(amount))

func show_damage_indicator(text_to_show : String):
	# Instancia un label indicando el daño recibido y lo agrega al árbol
	var dmg_label : FloatingText = damage_indicator_label.instance()
	dmg_label.init(text_to_show, FloatingText.Type.DAMAGE)
	dmg_label.position = global_position
	get_parent().add_child(dmg_label)

func show_gold_indicator(text_to_show : String):
	# Instancia un label indicando el daño recibido y lo agrega al árbol
	var dmg_label : FloatingText = damage_indicator_label.instance()
	dmg_label.init(text_to_show, FloatingText.Type.GOLD)
	dmg_label.position = global_position
	get_parent().add_child(dmg_label)

# TODO
func knockback(distance : Vector2):
	pass

func spawn():
	if $Anim.has_animation("Spawn"):
		$Anims.play("Spawn")

func dead():
	$Collision.disabled = true
	
	if $Anim.has_animation("Dead"):
		$Anims.play("Dead")

func _on_DamageDelay_timeout():
	can_damage = true

func _on_VisibilityNotifier_screen_entered():
	set_process(true)
	set_physics_process(true)
	visible = true

func _on_VisibilityNotifier_screen_exited():
	set_process(false)
	set_physics_process(false)
	visible = false

func _on_dead():
	Main.store_money += data.money_drop
	is_mark_to_dead = true
	
	show_gold_indicator("+" + str(data.money_drop))
	
	change_state(State.DIE)

func _on_Anims_animation_finished(anim_name):
	if anim_name == "Dead":
		queue_free()
