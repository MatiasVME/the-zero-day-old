extends Node

onready var damage = preload("res://scenes/cursor/images/damage.png")
onready var idle = preload("res://scenes/cursor/images/idle.png")
onready var object = preload("res://scenes/cursor/images/object.png")
onready var pointing = preload("res://scenes/cursor/images/pointing.png")

const HOTSPOT = Vector2(18, 18)

enum Cursor {
	DAMAGE, 
	IDLE, # CURSOR_ARROW
	OBJECT,
	POINTING
}

func _ready():
	Input.set_custom_mouse_cursor(idle, Input.CURSOR_ARROW, HOTSPOT)

func change_cursor(cursor):
	match cursor:
		Cursor.DAMAGE:
			Input.set_custom_mouse_cursor(damage, Input.CURSOR_ARROW, HOTSPOT)
		Cursor.IDLE:
			Input.set_custom_mouse_cursor(idle, Input.CURSOR_ARROW, HOTSPOT)
		Cursor.OBJECT:
			Input.set_custom_mouse_cursor(object, Input.CURSOR_ARROW, HOTSPOT)
		Cursor.POINTING:
			Input.set_custom_mouse_cursor(pointing, Input.CURSOR_ARROW, HOTSPOT)
			
