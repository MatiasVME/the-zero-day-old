tool

extends Panel

var is_open : bool = false

signal tools_toggled(toggled)

func _ready():
	$NavigationMapTool.connect("toggled", self, "_on_NavigationMapTool_toggled")

func _on_NavigationMapTool_toggled(toggled):
	if toggled == true:
		$tools.show()
	else:
		$tools.hide()
	is_open = toggled
	emit_signal("tools_toggled", toggled)

func show_navigation_map_tool():
	$NavigationMapTool.show()
	$NavigationMapTool.pressed = false
	$tools.hide()
	is_open = false
	
func hide_navigation_map_tool():
	$NavigationMapTool.hide()
	$tools.hide()
	is_open = false

func show_no_data_dialog():
	$NoDataDialog.popup_centered()

func show_no_data_in_res():
	$NoDataInRes.popup_centered()

func show_fail_load():
	$FailLoad.popup_centered()

func show_fail_save():
	$FailSave.popup_centered()

	