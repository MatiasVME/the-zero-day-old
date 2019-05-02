extends AI

class_name GPlayerAI

# Estados del personaje
enum STATE{
	IDLE,
	RANDOM_WALK,
	WALK_TARGET,
	ATTACK_TARGET
}

# Subestados de ATTACK_TARGET
enum ATTACK_STATE{
	CHASE, # Perseguir
	GO_BACK, # Retroceder
	DODGE # Esquivar
}
var attack_state

enum WALK_TARGET_STATE{
	WALKING,
	END
}
var walk_target_state

var FOLLOW_PLAYER := true
var PLAYER_TARGET



func _physics_process(delta):
	if not is_active : return
	
	match state:
		STATE.IDLE:
			idle_state()
			return
		STATE.RANDOM_WALK:
			random_walk_state(delta)
			return
		STATE.WALK_TARGET:
			walk_target_state(delta)
			return
		STATE.ATTACK_TARGET:
			attack_target_state()
			return

func idle_state() -> void:
	set_state(STATE.WALK_TARGET)
	
func random_walk_state(delta) -> void:
	random_walk(delta)
	
func walk_target_state(delta) -> void:
	if walk_target_state == WALK_TARGET_STATE.WALKING:
		move_to_point(delta, PLAYER_TARGET.position)
	else:
		actor._stop_handler(delta)

func attack_target_state() -> void:
	pass

# warning-ignore:unused_argument
func actor_entered(body) -> void:
	if body is GPlayer and body != actor:
		if not PLAYER_TARGET :
			PLAYER_TARGET = body
		walk_target_state = WALK_TARGET_STATE.END
		print("entered")
	
# warning-ignore:unused_argument
func actor_exited(body) -> void:
	if body is GPlayer and body != actor:
		walk_target_state = WALK_TARGET_STATE.WALKING
		move_state_x = false
		move_state_y = false
		print("exited")
	