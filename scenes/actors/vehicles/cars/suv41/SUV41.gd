extends Car

var current_player
var last_enter_area_tag

var co_pilot

func _ready():
	capacity = 2
	
	$EnterArea.connect("body_entered", self, "_on_EnterArea_body_entered", ["pilot"]) 
	$EnterArea.connect("body_exited", self, "_on_EnterArea_body_exited", ["pilot"])
	$EnterArea2.connect("body_entered", self, "_on_EnterArea_body_entered", ["co_pilot"]) 
	$EnterArea2.connect("body_exited", self, "_on_EnterArea_body_exited", ["co_pilot"])

func _input(event):
	current_player = PlayerManager.get_current_player()
	if event.is_action_released("ui_accept"):
		# Verifica si ya se ha subido a otro vehiculo, habra que añadir una variable especial
		if current_player.can_move: 
			if last_enter_area_tag == "pilot":
				if not pilot and .mount(current_player):
					mount_pilot(current_player)
			elif last_enter_area_tag == "co_pilot":
				if not .mount(current_player) : return
				if not pilot:
					mount_pilot(current_player)
				else:
					mount_co_pilot(current_player)
		else:
			if pilot == current_player:
				unmount(current_player)
			else:
				unmount(current_player)
			.leave(current_player)

func _physics_process(delta):
	update_drivers()

func update_drivers():
	if pilot : pilot.position = $PilotPos.global_position
	if co_pilot : co_pilot.position = $CoPilotPos.global_position
	
func mount_pilot(who):
	pilot = who
	who.disable_player()
	
func mount_co_pilot(who):
	co_pilot = who
	who.disable_player()
	
func unmount(who):
	if pilot == who : pilot = null
	else : co_pilot = null
	who.enable_player()
	who.can_move = true

func _on_EnterArea_body_entered(body, enter_area_tag):
	if not pilot and body == PlayerManager.get_current_player():
		last_enter_area_tag = enter_area_tag

func _on_EnterArea_body_exited(body, enter_area_tag):
	if body == PlayerManager.get_current_player():
		last_enter_area_tag = null