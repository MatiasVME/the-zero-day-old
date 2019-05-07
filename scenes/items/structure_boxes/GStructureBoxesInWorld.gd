extends KinematicBody2D

var start := false
var structure_type
var mark_to_dead = false

signal finished(structure_type)

# Al structurebox pasado como argumento, se le tiene que
# configurar el time_to_open y el structure_box_type
func setup(structure_box : ZDStructureBox):
	$Progress.max_value = structure_box.time_to_open
	$Progress.value = 0
	structure_type = structure_box.structure_box_type

func start():
	$TimerStep.start()

func _on_TimerStep_timeout():
	$Progress.value += $TimerStep.wait_time
	
	if $Progress.value >= $Progress.max_value:
		$TimerStep.stop()
		
		$Anim.play_backwards("show")
		mark_to_dead = true

func _on_Anim_animation_finished(anim_name):
	if anim_name == "show" and mark_to_dead:
		emit_signal("finished", structure_type)
		queue_free()
