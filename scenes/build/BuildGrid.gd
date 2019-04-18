extends Node2D

var img_selecting = preload("res://scenes/build/place/Selecting.png")
var img_cant_select = preload("res://scenes/build/place/CantSelecting.png")

enum GridState {
	HIDE,
	SELECTING,
	CANT_SELECT
}
var grid_state = GridState.HIDE setget set_grid_state, get_grid_state

var mouse_gpos

var tilemap
var structure
var actor
var build_id

func _ready():
	BuildManager.connect("prepare_to_build", self, "_on_prepare_to_build")
	
func setup(_tilemap : GTilemap, _structure : GStructure, _actor : GActor):
	tilemap = _tilemap
	structure = _structure
	actor = _actor
	
	grid_state = GridState.SELECTING

func _process(delta):
	match grid_state:
		GridState.HIDE:
			state_hide()
		GridState.SELECTING:
			state_selecting()
		GridState.CANT_SELECT:
			state_cant_select()

func set_grid_state(_grid_state):
	grid_state = _grid_state

func get_grid_state():
	return grid_state

func state_hide():
	hide()

func state_selecting():
	show()
	mouse_gpos = get_global_mouse_position()
	
	$Place.rect_position.x = mouse_gpos.x - (int(round(mouse_gpos.x)) % 16)
	$Place.rect_position.y = mouse_gpos.y - (int(round(mouse_gpos.y)) % 16)
	$Structure.rect_position = $Place.rect_position
	
	if Input.is_action_just_pressed("select"):
		var structure = BuildManager.get_constructible(build_id)
		structure.global_position = $Structure.rect_position
		structure.global_position.x += 8
		structure.global_position.y += 8
		get_parent().add_child(structure)
		
	print("selecting")
	
func state_cant_select():
	pass

func _on_prepare_to_build(tilemap, _build_id, actor):
	setup(tilemap, BuildManager.get_constructible(_build_id), actor)
	$Structure.texture = BuildManager.get_build_texture_for_terrain(_build_id)
	build_id = _build_id