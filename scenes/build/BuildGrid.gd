extends Node2D

var img_selecting = preload("res://scenes/build/place/Selecting.png")
var img_cant_select = preload("res://scenes/build/place/CantSelecting.png")

enum GridState {
	HIDE,
	SELECTING,
	CANT_SELECT
}
var grid_state = GridState.HIDE

var mouse_gpos

var gtilemap
var structure

func _ready():
	pass
	
func setup(gtilemap : GTilemap, structure : GStructure):
	pass

func _process(delta):
	match grid_state:
		GridState.HIDE:
			state_hide()
		GridState.SELECTING:
			state_selecting()
		GridState.CANT_SELECT:
			state_cant_select()

func state_hide():
	hide()

func state_selecting():
	mouse_gpos = get_global_mouse_position()
	
	$Place.rect_position.x = mouse_gpos.x - (int(round(mouse_gpos.x)) % 16)
	$Place.rect_position.y = mouse_gpos.y - (int(round(mouse_gpos.y)) % 16)
	
	if Input.is_action_just_pressed("select"):
		pass
	
func state_cant_select():
	pass
	
	