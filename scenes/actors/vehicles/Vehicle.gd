extends KinematicBody2D

class_name Vehicle

export (int) var capacity = 1
export var drivers = []
export (bool) var can_move = false

# Signals
signal mounted(who)
signal unmounted(who)
signal fulled
signal emptying

func mount(player):
	if drivers.size() < capacity:
		drivers.append(player)
		emit_signal("mounted", player)
		
		if drivers.size() == capacity:
			emit_signal("fulled")
		
		return true
	return false
	
func leave(player):
	drivers.pop_front()
	emit_signal("unmounted", player)
	
	if drivers.size() < 1:
		emit_signal("emptying")