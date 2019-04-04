extends GChest
"""
DropChest es un cofre que puede contener items y soltarlos al ser abierto
"""
class_name DropChest

onready var animation : = $AnimationChest
onready var timer_drop : = $TimerDrop
onready var sprite : = $Sprite
var interact : bool
var lock_unlock : bool = false #Variable para controlar si el cofre es bloqueable o desbloqueable
const PoolItem = preload("PoolItems.gd")
export (Texture) var texture_close = preload("images/Chest-0.png")
export (Texture) var texture_open = preload("images/Chest-2.png")
export (Texture) var texture_lock = preload("images/Chest-0.png")

func _ready():
	connect("chest_opened", self, "_on_chest_opened")
	connect("chest_closed", self, "_on_chest_closed")
	connect("chest_locked", self, "_on_chest_locked")
	set_process_unhandled_input(false)
	match state:
			States.CLOSED:
				sprite.texture = texture_close
			States.OPENED:
				sprite.texture = texture_open
			States.LOCKED:
				sprite.texture = texture_lock
	
func _unhandled_input(event):
	if event is InputEvent:
		interact = Input.is_action_just_pressed("interact")
	
	if interact:
		interact = false
		match state:
			States.CLOSED:
				if lock_unlock:
					lock_chest()
				else:
					open_chest()
			States.OPENED:
				close_chest()
			States.LOCKED:
				if lock_unlock:
					unlock_chest()
				else:
					animation.play("Lock")

	
func add_random_items(pool_items : PoolItem) -> void:
	if not pool_items:
		return
		
	while not is_full() and not pool_items.is_empty():
		var item : PHItem = pool_items.get_random_item()
		add_item(item)
	
func _on_chest_opened() -> void:
	if not animation.is_playing():
		animation.play("Open")
	
func _on_chest_closed() -> void:
	if not animation.is_playing():
		animation.play("Close")
		
func _on_chest_locked() -> void:
	if not animation.is_playing():
		animation.play("Lock")
		
#Función sobreescrita de GChest que define la máquina de estados
func _change_state(new_state : int) -> bool:
	match new_state:
		States.OPENED:
			if state == States.CLOSED:
				state = new_state
		_:
			return false
	return true

func _on_AnimationChest_animation_finished(anim_name):
	match anim_name:
		"Open":
			while not is_empty():
				timer_drop.start()
				yield(timer_drop, "timeout")
	
func _on_InteracArea_body_entered(body):
#TODO:Ver que otra condición agregar para que se trate del current player
#cuando haya más de un player
	if body is GPlayer and body == PlayerManager.get_current_player():
		set_process_unhandled_input(true)
	
func _on_InteracArea_body_exited(body):
	if body is GPlayer and body == PlayerManager.get_current_player():
		set_process_unhandled_input(false)
	
func _on_TimerDrop_timeout():
		var item = drop_item()
		var item_in_world = Factory.ItemInWorldFactory.create_from_item(item)
		item_in_world.global_position = global_position + Vector2(rand_range(-20.0, 20.0), rand_range(-20.0, 20.0))
		get_parent().add_child(item_in_world)

func test() -> void:
	add_random_items( test_pool_items() )
	
func test_pool_items() -> PoolItem:
	var pool_items = PoolItem.new()
	pool_items.test()
	return pool_items