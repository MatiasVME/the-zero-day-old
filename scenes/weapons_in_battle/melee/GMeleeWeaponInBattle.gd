extends GWeaponInBattle

class_name GMeleeWeaponInBattle

# WeaponSprite RotationDegrees
var ws_rd = 0

var is_near = false

func _process(delta):
	ws_rd = rotation_degrees
	
	if ws_rd > 90 and ws_rd < 270 or ws_rd < -90 and ws_rd > -270:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
		
	if ws_rd < -360 or ws_rd > 360:
		rotation_degrees = 0

func _on_IsNearAttackArea_body_entered(body):
	if body is GActor and body.actor_owner == body.ActorOwner.ENEMY:
		is_near = true
		print_debug("is_near: ", body.name)

func _on_IsNearAttackArea_body_exited(body):
	if body is GActor and body.actor_owner == body.ActorOwner.ENEMY:
		is_near = false
		print_debug("not_near: ", body.name)
