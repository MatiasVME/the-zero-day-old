extends Node2D

class_name FloatingText

onready var label : = $Label
onready var tween : = $Tween
enum Type {DAMAGE, HEAL}
const COLORS = {Type.DAMAGE : Color.red, Type.HEAL : Color.green}
var amount : int
var type : int

func init(value : int = 0, type : int = Type.DAMAGE):
	self.amount = value
	self.type = type
	
func _ready():
	label.text = str(amount)
	label.set("custom_colors/font_color", COLORS[type])
	tween.interpolate_property(self, "position", position + Vector2(0, -4), position + Vector2(0, -20), 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN )
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0.80), Color(1, 1, 1, 0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start()

func _on_Tween_tween_completed(object, key):
	if key.get_subname(0) == "modulate":
		queue_free()
	pass