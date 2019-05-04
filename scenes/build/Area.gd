extends TextureRect

var texture_enable = preload("res://scenes/build/place/Selecting.png")
var texture_disabled = preload("res://scenes/build/place/CantSelecting.png")

func disable_area():
	$IsBuildable/Collision.disabled = true
	hide()
	
func enable_area():
	$IsBuildable/Collision.disabled = false
	show()

func _on_IsBuildable_body_entered(body):
	texture = texture_disabled

func _on_IsBuildable_body_exited(body):
	texture = texture_enable
