extends Node2D

class_name FloatingText

onready var label := $Label
onready var tween := $Tween
enum Type {DAMAGE, HEAL}
const COLORS = {Type.DAMAGE : Color.red, Type.HEAL : Color.green}
var amount : int
var type : int

var velocity = Vector2(50, -100)
var gravity = Vector2(0, 1)
var mass = 200

func init(value : int = 0, type : int = Type.DAMAGE):
	self.amount = value
	self.type = type
	
func _ready():
	randomize()
	
	label.text = str(amount)
	label.set("custom_colors/font_color", COLORS[type])
	
	velocity = Vector2(rand_range(-50, 50), -100)
	mass = int(rand_range(150, 250))
	modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	"""
	Fade from current color after 0.7 seconds
	"""
	
	tween.interpolate_property(self, "modulate", 
		Color(modulate.r, modulate.g, modulate.b, modulate.a), 
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	
	"""
	Increase size
	After 0.6 seconds, start to shrink slightly
	"""
	
	tween.interpolate_property(self, "scale", 
		Vector2(0, 0), 
		Vector2(1.0, 1.0),
		0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	tween.interpolate_property(self, "scale", 
		Vector2(1.0, 1.0), 
		Vector2(0.4, 0.4),
		1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)
	
	tween.start()

func _process(delta):
	velocity += gravity * mass * delta
	position +=  velocity * delta

func _on_Tween_tween_completed(object, key):
	if key.get_subname(0) == "modulate":
		queue_free()