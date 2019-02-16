extends RigidBody2D

class_name ItemInWorld

var data : PHItem setget set_data

enum ItemState {
	IDLE,
	SEEKER
}
var item_state = ItemState.IDLE

var mouse_entered = false

func _physics_process(delta):
	if PlayerManager.get_current_player() and item_state == ItemState.SEEKER:
		set_axis_velocity((PlayerManager.current_player.global_position - global_position) * 80 * delta) 

func set_data(_data):
	data = _data
	$Images/Item.texture = load(data.texture_path)

func _on_Anim_animation_finished(anim_name):
	if anim_name == "show":
		$Anim.play("idle")

func _on_InteractArea_mouse_entered():
	mouse_entered = true

func _on_InteractArea_mouse_exited():
	mouse_entered = false

func _on_InteractArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("select"):
		item_state = ItemState.SEEKER