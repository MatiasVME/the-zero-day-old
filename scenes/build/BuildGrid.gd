extends Node2D

var img_selecting = preload("res://scenes/build/place/Selecting.png")
var img_cant_select = preload("res://scenes/build/place/CantSelecting.png")

enum GridState {
	HIDE,
	INIT_CORE,
	SELECTING,
	CANT_SELECT
}
var grid_state = GridState.HIDE setget set_grid_state, get_grid_state

var is_setup = false

var mouse_gpos : Vector2
var cursor_position := Vector2(1, 1)
var cursor_size : Vector2

var tilemap
var structure
var structure_box
var structure_box_in_world
var build_location : Vector2
var actor
var build_id

onready var initial_players = get_tree().get_nodes_in_group("Player")

func _ready():
	BuildManager.connect("prepare_to_build", self, "_on_prepare_to_build")
	
	if initial_players.size() == 0:
#		grid_state = GridState.INIT_CORE
		pass
	
func setup(_tilemap : GTilemap, _build_id : int, _actor):
	if is_setup:
		return
	
	tilemap = _tilemap
	build_id = _build_id
	structure = BuildManager.get_constructible(build_id)
	structure_box = BuildManager.get_structure_box(build_id)
	actor = _actor
	
	is_setup = true
	
	if _actor:
		grid_state = GridState.SELECTING

func reset_setup():
	tilemap = null
	structure = null
	actor = null
	is_setup = false
	
func _process(delta):
	match grid_state:
		GridState.HIDE:
			state_hide()
		GridState.INIT_CORE:
			state_inite_core()
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

func state_inite_core():
	show()
	
	mouse_gpos = get_global_mouse_position()
	$BuildArea.position.x = (mouse_gpos.x - (int(abs(mouse_gpos.x)) % 16)) - cursor_position.x * 16
	$BuildArea.position.y = (mouse_gpos.y - (int(abs(mouse_gpos.y)) % 16)) - cursor_position.y * 16

	if Input.is_action_just_pressed("select"):
		structure.global_position = $BuildArea.position
		structure.global_position += 8 * cursor_size
		
		get_parent().add_child(structure)

		grid_state = GridState.HIDE

func state_selecting():
	show()
	
	mouse_gpos = get_global_mouse_position()
	$BuildArea.position.x = (mouse_gpos.x - (int(abs(mouse_gpos.x)) % 16)) - cursor_position.x * 16
	$BuildArea.position.y = (mouse_gpos.y - (int(abs(mouse_gpos.y)) % 16)) - cursor_position.y * 16

	if Input.is_action_just_pressed("select"):
		structure_box_in_world = BuildManager.get_structure_box_in_world(Enums.StructureType.COMMON_FACTORY)
		structure_box_in_world.global_position.x = $BuildArea.position.x + 8 + 16
		structure_box_in_world.global_position.y = $BuildArea.position.y + 8 + 16
		
		get_parent().get_parent().add_child(structure_box_in_world)
		
		structure_box_in_world.connect("finished", self, "_on_structure_box_finished")
		structure_box_in_world.start()

		grid_state = GridState.HIDE
	
func state_cant_select():
	pass

func adaptate_cursor(_structure : GStructure):
	match _structure.structure_size:
		Enums.StructureSize.W1X1:
			pass
		Enums.StructureSize.S1X1:
			cursor_size = Vector2(1, 1)
		Enums.StructureSize.S2X2:
			cursor_size = Vector2(2, 2)
			
			$BuildArea/BuildArea/Area3.disable_area()
			$BuildArea/BuildArea/Area6.disable_area()
			$BuildArea/BuildArea/Area7.disable_area()
			$BuildArea/BuildArea/Area8.disable_area()
			$BuildArea/BuildArea/Area9.disable_area()
		Enums.StructureSize.S3X3:
			cursor_size = Vector2(3, 3)
			$Place.rect_size = 16 * cursor_size
		Enums.StructureSize.S2X3:
			cursor_size = Vector2(2, 3)
			$Place.rect_size = 16 * cursor_size
		Enums.StructureSize.S3X2:
			cursor_size = Vector2(3, 2)
			$Place.rect_size = 16 * cursor_size
	
func _on_structure_box_finished(structure_type):
	structure.global_position = $BuildArea.position + 8 * cursor_size
	get_parent().get_parent().add_child(structure)
	
func _on_prepare_to_build(tilemap, _build_id, actor):
	# A veces actor puede ser null, esto es en los
	# casos de que se necesite crear el core primero
	# y luego el player
	setup(tilemap, _build_id, actor)
	adaptate_cursor(structure)
	
	if not actor:
		grid_state = GridState.INIT_CORE
	