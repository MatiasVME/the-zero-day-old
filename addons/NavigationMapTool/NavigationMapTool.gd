tool
extends EditorPlugin

const _tool = preload("res://addons/NavigationMapTool/Tool.tscn")

const NavigationMap = preload("res://navigation/NavigationMap.gd")

var tool_instance

var navigation_map_node : NavigationMap
var navigation_map_data

func _enter_tree():
	tool_instance = _tool.instance()
	tool_instance.get_node("tools/Save").connect("pressed", self, "_on_SaveButton")
	tool_instance.connect("tools_toggled", self, "_on_tools_toggled")
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, tool_instance)

func _exit_tree():
	remove_control_from_bottom_panel(tool_instance)
	tool_instance.queue_free()
	
func get_plugin_name():
	return "NavigationMapTool"

func handles(object) -> bool:
	if object is NavigationMap:
		navigation_map_node = object
		print("NavigationMap Selected")
		tool_instance.show_navigation_map_tool()
		return true
	else:
		if navigation_map_node and navigation_map_node.is_connected("data_file_path_changed", self, "_on_data_file_path_changed"):
			navigation_map_node.disconnect("data_file_path_changed", self, "_on_data_file_path_changed")
		navigation_map_node = null
		navigation_map_data = null
		tool_instance.hide_navigation_map_tool()
		update_overlays()
		return false

func forward_canvas_gui_input(event) -> bool:
	if not tool_instance.is_open : return false
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			
			if navigation_map_node.data_file_path == "":
				tool_instance.show_no_data_dialog()
				return true
			
			var viewport_transform_inv := navigation_map_node.get_viewport().get_global_canvas_transform().affine_inverse()
			var viewport_position: Vector2 = viewport_transform_inv.xform(event.position)
			var transform_inv := navigation_map_node.get_global_transform().affine_inverse()
			var target_position : Vector2 = transform_inv.xform(viewport_position.round())
			
			var x = floor(target_position.x / 16)
			var y = floor(target_position.y / 16)
			
			var tile_pos = Vector2(x,y)
			
			if navigation_map_data.has(tile_pos):
				navigation_map_data.erase(tile_pos)
				
			else:
				navigation_map_data.append(tile_pos)
			
			update_overlays()
			
			return true
		return false
	else:
		return false

func forward_canvas_draw_over_viewport(overlay : Control):
	if not tool_instance.is_open : return
	draw_tiles_pos(overlay, navigation_map_data)
	
func draw_tiles_pos(overlay : Control, tiles_pos : Array):
	var viewport = navigation_map_node.get_viewport_transform()
	var canvas = navigation_map_node.get_canvas_transform()
	for tile_pos in tiles_pos:
		draw_tile_pos(overlay, viewport , canvas, tile_pos)

func draw_tile_pos(overlay, viewport , canvas, tile_pos):
	var pos = viewport * (canvas*tile_pos*16)
	var end = viewport * (canvas*(tile_pos*16 + Vector2(16,16)))
	overlay.draw_rect(Rect2(pos,end-pos), Color(0.2,0.1,0.4,0.6), true)
	overlay.draw_rect(Rect2(pos,end-pos), Color.blueviolet, false)

func _on_data_file_path_changed():
	if not tool_instance.is_open : return
	if navigation_map_node.data_file_path == "":
		tool_instance.show_no_data_dialog()
		return
	var err = load_data()
	if err :
		tool_instance.show_fail_load()
	update_overlays()

func _on_tools_toggled(toggled):
	if toggled:
		if navigation_map_node.data_file_path == "":
			tool_instance.show_no_data_dialog()
			tool_instance.get_node("NavigationMapTool").pressed = false
			tool_instance.is_open = false
			tool_instance.get_node("tools").hide()
		else:
			var err = load_data()
			if err :
				tool_instance.show_fail_load()
			update_overlays()
			navigation_map_node.connect("data_file_path_changed", self, "_on_data_file_path_changed")
	else:
		navigation_map_data = null
		update_overlays()
		navigation_map_node.disconnect("data_file_path_changed", self, "_on_data_file_path_changed")

func _on_SaveButton():
	if navigation_map_node.data_file_path == null:
		tool_instance.show_no_data_dialog()
		return true
	var err = save_data()
	if err :
		tool_instance.show_fail_save()
		print("Not Saved")
		return
	print("Save Successful")


func load_data() -> bool:
	var data_file = File.new()
	data_file.open(navigation_map_node.data_file_path, 3)
	navigation_map_data = data_file.get_var()
	data_file.close()
	if not (navigation_map_data is Array) :
		navigation_map_data = []
	return false

func save_data() -> bool:
	var data_file = File.new()
	data_file.open(navigation_map_node.data_file_path, 3)
	data_file.store_var(navigation_map_data)
	data_file.close()
	return false
	