extends Node2D

const CELL = 32

enum KState {
	SEEKER,
	RANDOM
}
var k_state = KState.RANDOM

enum KMoveDir {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_RIGHT,
	BOTTOM_LEFT
}
var k_move_dir

enum KMoveFigure {
	TOP_RIGHT,
	RIGHT_TOP
}
var k_move_figure

enum KMove {
	SHORT,
	LONG,
	WAIT
}
var k_move = KMove.WAIT

const LONG_MOVE = CELL * 3
const SHORT_MOVE = CELL * 2

var current_objective = Vector2()
# Es el objetivo más la posición actual
var objective = Vector2()

func _ready():
	randomize()
	current_objective = get_current_objective()
	objective = get_current_objective() + $K.global_position

func _physics_process(delta):
#	if globa
	pass
	
	
# Dice el objetivo al cual se tiene que mover actualmente
func get_current_objective():
	current_objective = Vector2()
	
	if k_move == KMove.WAIT:
		k_move = int(round(rand_range(KMove.SHORT, KMove.LONG)))
		k_move_figure = int(round(rand_range(KMoveFigure.TOP_RIGHT, KMoveFigure.RIGHT_TOP)))
#		k_move_dir = int(round(rand_range(KMoveDir.TOP_LEFT, KMoveDir.BOTTOM_LEFT)))
	if k_move == KMove.LONG:
		if k_move_figure == KMove.TOP_RIGHT:
			current_objective.y = LONG_MOVE
		elif k_move_figure == KMove.RIGHT_TOP:
			current_objective.x = LONG_MOVE
	elif k_move == KMove.SHORT:
		if k_move_figure == KMove.TOP_RIGHT:
			current_objective.y = SHORT_MOVE
		elif k_move_figure == KMove.RIGHT_TOP:
			current_objective.x = SHORT_MOVE
	
	return current_objective
	
	
	