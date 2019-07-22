extends GEnemy

var speed = 100
var nav = null setget set_nav
var path = []
var goal = Vector2()
var move_pos = Vector2()

func _physics_process(delta):
	if path.size() > 1:
		var d = position.distance_to(path[0])
		
		if d > 2:
			# debería devolver la posición siguiente a la
			# que se quiere mover, segun el path finding		
			position = position.linear_interpolate(path[0], (speed * delta)/d)
#			print(path[0])
#			print(move_pos)
#			move_and_slide(move_pos.normalized() * delta * speed)
			pass
		else:
			path.remove(0)

func _input(event):
	if event.is_action_pressed("fire"):
		goal = get_global_mouse_position()
		update_path()

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	path = nav.get_simple_path(position, goal, false)

func _on_Cornus_ready():
	# Es el map (Navigation2D)
	if get_tree().has_group("Map"):
		nav = get_tree().get_nodes_in_group("Map")[0]
		set_nav(nav)
	else:
		print("No existe grupo Map para Cornus")
