extends CanvasLayer

enum StructurePanel {
	CORE
}
var current_panel

var is_hiding = false

# Recibe una constante de StructurePanel
func show_panel(structure_panel):
	_add_panel(structure_panel)
	is_hiding = false
	
	# Curtain
	$Curtain.show()
	$CurtainTween.interpolate_property(
		$Curtain, 
		"color",
		Color("00000000"),
		Color("64000000"),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$CurtainTween.start()
	
	# Current Panel
	$PanelTween.interpolate_property(
		current_panel, 
		"scale",
		Vector2(),
		Vector2(1,1),
		0.4,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
	)
	$PanelTween.start()
	
func hide_panel():
	is_hiding = true
	
	# Curtain
	$CurtainTween.interpolate_property(
		$Curtain, 
		"color",
		Color("64000000"),
		Color("00000000"),
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$CurtainTween.start()
	
	# Current Panel
	$PanelTween.interpolate_property(
		current_panel, 
		"scale",
		Vector2(1,1),
		Vector2(),
		0.4,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
	)
	$PanelTween.start()

func _on_ColorRect_mouse_entered():
#	hide_panel()
	pass

func _on_PanelTween_tween_completed(object, key):
	if is_hiding:
		_remove_panel()

func _add_panel(panel):	
	match panel:
		StructurePanel.CORE:
			current_panel = load("res://scenes/panels/core_panel/CorePanel.tscn").instance()
	
	add_child(current_panel)
	
func _remove_panel():
	current_panel.queue_free()