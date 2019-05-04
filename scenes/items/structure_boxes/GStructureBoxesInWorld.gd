extends KinematicBody2D

var start := false
var structure_type

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
	
	if $Progress.value == $Progress.max_value:
		emit_signal("finished", structure_type)
		$TimerStep.stop()
		queue_free()
