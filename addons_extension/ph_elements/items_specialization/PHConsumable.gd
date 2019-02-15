extends PHItem

class_name PHConsumable

signal consumed

# Emite la señal consumed y luego se borra el item
func consume():
	emit_signal("consumed")
	queue_free()