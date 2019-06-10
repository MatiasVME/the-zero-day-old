extends Node2D

class_name GSpawnPlace

export (bool) var only_player = false

# Los monstruos que spawnea
var monsters = []

func spawn():
	pass

func _on_VisibilityNotifier_screen_entered():
	set_process(true)

func _on_VisibilityNotifier_screen_exited():
	set_process(false)
