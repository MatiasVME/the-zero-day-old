extends GEnviroment

class_name GTree

func _on_DetectArea_body_entered(body):
	if body is GPlayer:
		$ShowHide.play("Hide")

func _on_DetectArea_body_exited(body):
	if body is GPlayer:
		$ShowHide.play("Show")