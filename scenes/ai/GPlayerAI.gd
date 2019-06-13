extends AI

class_name GPlayerAI

# Estados del personaje
enum STATE{
	IDLE, 
	RANDOM_WALK, # Movimiento aleatorio
	FOLLOW_PLAYER, # Seguir al jugador
	FOLLOW_TARGET, # Perseguir Objetivo
	GO_BACK_TARGET # Alejarse del objetivo
}

var is_doging := false
var is_attacking := false

var FOLLOW_PLAYER := true

var PLAYER_TARGET

enum MOVING_STATE{
	MOVING,
	END
}

var moving_state : int = MOVING_STATE.END

func _physics_process(delta):
	if not is_active : return
	
	match state:
		STATE.IDLE:
			idle_state(delta)
		STATE.RANDOM_WALK:
			random_walk_state(delta)
		STATE.FOLLOW_PLAYER:
			follow_player_state(delta)
		STATE.FOLLOW_TARGET:
			follow_target_state()
		STATE.GO_BACK_TARGET:
			go_back_target_state()

func idle_state(delta) -> void:
	actor._stop_handler(delta)
	
func random_walk_state(delta) -> void:
	random_walk(delta)
	
func follow_player_state(delta) -> void:
	if moving_state == MOVING_STATE.MOVING:
		if actor.position.distance_to(PLAYER_TARGET.position) > 30:
			move_to_point(delta, PLAYER_TARGET.position)
		else:
			moving_state = MOVING_STATE.END
			random_walk_area_center = PLAYER_TARGET.position
			time_to_update_random_walk_progress = 0
			target_point = actor.position
			self.is_moving = false
			print(random_walk_area_center)
			set_state(STATE.RANDOM_WALK)
	

func follow_target_state() -> void:
	pass

func go_back_target_state() -> void:
	pass

# warning-ignore:unused_argument
func actor_entered(body) -> void:
	if body is GPlayer and body != actor:
		return
		
		#print("entered")

# warning-ignore:unused_argument
func actor_exited(body) -> void:
	if body is GPlayer and body != actor:
		set_state(STATE.FOLLOW_PLAYER)
		moving_state = MOVING_STATE.MOVING
		self.is_moving = true
		print("exited")
