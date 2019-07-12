extends KinematicBody2D

class_name GActor

# Cuando esta marcado para morir, es para evitar que
# muera mas de una vez o se haga la animacion de morir 
# mas de una vez
var is_mark_to_dead = false

var can_move := false

var is_disabled := false

# Variable que se puede usar para debugear y otras cosas
var is_inmortal := false

func dead():
	queue_free()