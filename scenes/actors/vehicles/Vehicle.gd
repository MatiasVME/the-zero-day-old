extends KinematicBody2D

class_name Vehicle

#Signals
signal unmount_vehicle
signal enable_vehicle

#Properties
export (bool) var _driver = null #Alternativas: bool o GPlayer

func _ready():
	connect("enable_vehicle", get_tree().root.get_node("TTank/Matbot"), "set_vehicle")
	connect("unmount_vehicle", get_tree().root.get_node("TTank/Matbot"), "enable_player")

func mount_vehicle():
	_driver = true

func leave_vehicle():
	_driver = false

func _get_input(delta : float) -> void:
	pass

func _on_Entry_Area_body_entered(body):
	if body.name == "Matbot" && not _driver:
		emit_signal("enable_vehicle", self)
		print("Disponible")


func _on_Entry_Area_body_exited(body):
	emit_signal("enable_vehicle", null)
