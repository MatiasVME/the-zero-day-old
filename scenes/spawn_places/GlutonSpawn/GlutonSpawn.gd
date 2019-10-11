extends GSpawnPlace

onready var gluton = preload("res://scenes/actors/enemies/gluton/Gluton.tscn")

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
	var instance = gluton.instance()
	get_parent().add_child(instance)
	instance.global_position = $Pos.global_position
	
func _on_TouchForSpawn_body_entered(body):
	if not only_player and body is GEnemy:
		$Delay.start()
	elif not only_player and body is GPlayer:
		$Delay.start()
	elif only_player and body is GPlayer:
		$Delay.start()

func _on_Delay_timeout():
	spawn()