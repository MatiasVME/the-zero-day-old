extends GSpawnPlace

onready var gluton = preload("res://scenes/actors/enemies/gluton/Gluton.tscn").instance()

var ot_queue = true

# Cuerpo tocado
var body

func _ready():
	monsters.append(gluton)
	
func _process(delta):
	if ot_queue and $Signals.frame == 10:
		queue_free()
		ot_queue = false

func spawn():
	.spawn()
	
	spawn_gluton()
	
	$Signals.play("default")
	$Spawn.play()

func spawn_gluton():
	get_parent().add_child(gluton)
	gluton.global_position = $Pos.global_position
	
func _on_TouchForSpawn_body_entered(body):
	if not only_player and body is GActor:
		$Delay.start()
	elif only_player and body is GPlayer:
		$Delay.start()

func _on_Delay_timeout():
	spawn()