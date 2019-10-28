extends KinematicBody2D

class_name GActor

enum ActorOwner {ENEMY, PLAYER, NATURE}
var actor_owner = ActorOwner.ENEMY

# Cuando esta marcado para morir, es para evitar que
# muera mas de una vez o se haga la animacion de morir 
# mas de una vez
var is_mark_to_dead = false

var can_move := false

var is_disabled := false

# Variable que se puede usar para debugear y otras cosas
var is_inmortal := false

# A veces en Godot 3.1 no es posible utilizar el operador
# is por dependencias cíclicas, estonces se pueden,
# identificar por un nombre
var actor_name := ""

