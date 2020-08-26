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

class_name GEnemyOld

var damage_indicator_label = preload("res://scenes/hud/floating_hud/FloatingText.tscn")

# Debe tener esta variable para que la camara pueda seguir a este
# enemigo. Ya que los GPlayer tienen esta variable.
# NEEDFIX
var selected_num := -1 # -1 es nignuno seleccionado

var was_attacked_by_a_player := false

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
	
#func _ready():
#	data.connect("dead", self, "_on_dead")

# Esta funcion es una forma segura de cambiar entre estados.
func change_state(_state): 
	if current_state != _state:
		state = _state
		current_state = _state
		emit_signal("state_changed")

# Todos los enemigos tienen estos metodos como minimo
#

func damage(amount, who : GActor):
	if not can_damage and not is_instance_valid(who):
		return
	
	$Anims/Damage.play("Damage")
	
	if who.actor_owner == Enums.ActorOwner.ENEMY or who.actor_owner == Enums.ActorOwner.PLAYER:
		data.damage(amount, who.data)
	else:
		print_debug(who.get_name(), " no es gactor ni gplayer")
	
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
	if $Anims.has_animation("Spawn"):
		$Anims.play("Spawn")

func dead():
	$Collision.disabled = true
	
	if $Anims.has_animation("Dead"):
		$Anims.play("Dead")
		
	is_mark_to_dead = true
	
	if was_attacked_by_a_player():
		Main.store_money += data.money_drop
		show_gold_indicator("+" + str(data.money_drop))
	
	change_state(State.DIE)

# Devuelve true si fue atacado alguna vez por un jugador
func was_attacked_by_a_player():
	# Esto evita que se llame al for mas de lo necesario
	if was_attacked_by_a_player:
		return true
	
	for rpg_character in data.those_who_damaged:
		if rpg_character.character_owner == Enums.ActorOwner.PLAYER:
			was_attacked_by_a_player = true
			return true
	
	return false

func _on_DamageDelay_timeout():
	can_damage = true

func _on_Anims_animation_finished(anim_name):
	if anim_name == "Dead":
		queue_free()
