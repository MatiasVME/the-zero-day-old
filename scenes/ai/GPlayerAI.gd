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

func _physics_process(delta):
	if not is_active : return
	
	match state:
		STATE.IDLE:
			return
		STATE.RANDOM_WALK:
			return
		STATE.WALK_TARGET:
			return
		STATE.ATTACK_TARGET:
			return
