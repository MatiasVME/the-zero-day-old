extends GChest
"""
NormalChest es un cofre sin llave que puede contener items normales
"""
onready var animation : = $AnimationChest
var interact : bool

func _ready():
	add_random_items()#Para pruebas
	connect("chest_opened", self, "_on_chest_opened")
	connect("chest_closed", self, "_on_chest_closed")
	set_process_unhandled_input(false)
	
func _unhandled_input(event):
	if event is InputEvent:
		interact = Input.is_action_just_pressed("interact")
	
	if interact:
		interact = false
		if state == States.CLOSED:
			open_chest()
		else:
			close_chest()

#Funcion para definir los tipos de items que puede contener
#si se utiliza el llenado aleatorio 	
func create_pool_items() -> Array:
	var pool_items : Array = []
	pool_items.append("Normal Ammo 8")
	pool_items.append("Normal Ammo 8")
	pool_items.append("Normal Ammo 16")
	pool_items.append("Normal Ammo 32")
	pool_items.append("Plasma Ammo 8")
	pool_items.append("Plasma Ammo 16")
	return pool_items
	
func add_random_items() -> void:
	var pool_items : Array = create_pool_items()
	var random : = RandomNumberGenerator.new()
	random.randomize()
	while not is_full():
		var item : PHItem
		match pool_items[random.randi() % pool_items.size()]:
			"Normal Ammo 8":
				item = Factory.ItemFactory.create_normal_ammo(8)
			"Normal Ammo 16":
				item = Factory.ItemFactory.create_normal_ammo(16)
			"Normal Ammo 32":
				item = Factory.ItemFactory.create_normal_ammo(32)
			"Plasma Ammo 8":
				item = Factory.ItemFactory.create_plasma_ammo(8)
			"Plasma Ammo 16":
				item = Factory.ItemFactory.create_plasma_ammo(16)
		add_item(item)
	
func _on_chest_opened() -> void:
	if not animation.is_playing():
		animation.play("Open")
	
func _on_chest_closed() -> void:
	if not animation.is_playing():
		animation.play("Close")

#Función sobreescrita de GChest que define la máquina de estados
func _change_state(new_state : int) -> bool:
	match new_state:
		States.CLOSED:
			if state == States.OPENED:
				state = new_state
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
				var item = drop_item()
				var item_in_world = Factory.ItemInWorldFactory.create_from_item(item)
				item_in_world.global_position = global_position + Vector2(rand_range(-20.0, 20.0), 20)
				get_parent().add_child(item_in_world)


func _on_InteracArea_body_entered(body):
#TODO:Ver que otra condición agregar para que se trate del current player
	if body is GPlayer:
		set_process_unhandled_input(true)
	
func _on_InteracArea_body_exited(body):
	if body is GPlayer:
		set_process_unhandled_input(false)
