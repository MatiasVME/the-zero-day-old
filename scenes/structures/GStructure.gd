# Estructuras fijas con las que se puede interactuar

extends KinematicBody2D

class_name GStructure

var is_invulnerable : bool = false
var is_mark_to_destroy : bool = false

enum StructureSize {
	W1X1, # Wall 1x1
	S1X1, # Structure 1x1
	S2X2, # ... 2x2
	S3X3, # ..
	S2X3,
	S3X2
}
var structure_size

