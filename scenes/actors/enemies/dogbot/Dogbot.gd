extends GEnemy

func _ready():
	state = State.STAND
	
	$Body.playing = true
	$DamageDelay.set_wait_time(0.2)
	
	randomize()
	
	data.max_hp = int(round(rand_range(20, 30)))
	data.restore_hp()
	data.xp_drop = 2 # temp
	data.attack = 6
	data.money_drop = int(rand_range(30, 60))
	
	data.connect("dead", self, "_on_dead")
	
func _physics_process(delta):
	match state:
		State.STAND: state_stand()
		State.SEEKER: state_seeker()
		State.ATTACK: state_attack()
		State.DIE: state_die()

func state_stand():
	$Sprites/AnimIdle.play("Idle")

func state_seeker():
	pass
	
func state_attack():
	pass
	
func state_die():
	pass

func _on_dead():
	pass
	
	