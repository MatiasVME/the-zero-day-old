extends TextureRect

# Se usa para saber si el slot esta en un area valida o no
var is_selectable := false
# Se usa para saber si el slot esta habilitado o deshabilitado
var is_disabled := false

var texture_enable = preload("res://scenes/build/place/Selecting.png")
var texture_disabled = preload("res://scenes/build/place/CantSelecting.png")

func disable_area():
	$IsBuildable/Collision.disabled = true
	texture = null
	is_disabled = true
	
func enable_area():
	$IsBuildable/Collision.disabled = false
	texture = texture_enable
	is_disabled = false

func _on_IsBuildable_body_entered(body):
	texture = texture_disabled
	is_selectable = false

func _on_IsBuildable_body_exited(body):
	if not $IsBuildable/Collision.disabled:
		texture = texture_enable
		is_selectable = true
	else:
		texture = null
