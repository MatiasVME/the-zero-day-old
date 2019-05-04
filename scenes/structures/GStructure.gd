# Estructuras fijas con las que se puede interactuar

extends KinematicBody2D

class_name GStructure

var is_invulnerable := false
var is_mark_to_destroy := false
# Se puede interactuar con el? Es util cuando queremos
# desplegar un panel cuando presionamos la tecla e
# o interact
var is_interactable := false

var structure_owner : String

var _can_iteract := false

# De momento esto esta replicado en el Enums, mas adelante
# hay que borrarlo
enum StructureSize {
	W1X1, # Wall 1x1
	S1X1, # Structure 1x1
	S2X2, # ... 2x2
	S3X3, # ..
	S2X3,
	S3X2
}
var structure_size

signal interacted

func _on_InteractArea_body_entered(body):
	if body is GPlayer:
		_can_iteract = true

func _on_InteractArea_body_exited(body):
	if body is GPlayer:
		_can_iteract = false
	