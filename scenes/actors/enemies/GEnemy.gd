extends KinematicBody2D

class_name GEnemy

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
