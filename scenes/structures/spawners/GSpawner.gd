extends GStructure

class_name GSpawner

enum State {
	GENERATING, # Cuando esta generando objetos
	RESTING, # Cuando deja de spawnear cosas
	DESTROYED
}
var state : int = 0

var spawn_object = null
var max_spawn_radius : float = 40
var min_spawn_radius : float = 10

var min_num_spawns : int = 1
var max_num_spawns : int = 2

var max_objects_in_area : int = 6

var spawn_delay : float = 5
var spawn_time : float = 0

var players_in_active_area : int = 0
var object_in_active_area : int = 0

var data

signal state_changed
signal spawn_object_changed

func _init():
	change_state(State.RESTING)
	data = PHStructure.new()
	
func _ready():
	
	$DamageArea.connect("body_entered", self, "_on_DamageArea_body_entered")
	
	$ActiveArea.connect("body_entered", self, "_on_ActiveArea_body_entered")
	$ActiveArea.connect("body_exited", self, "_on_ActiveArea_body_exited")
	$ObjectsArea.connect("body_entered", self, "_on_ObjectsArea_body_entered")
	$ObjectsArea.connect("body_exited", self, "_on_ObjectsArea_body_exited")
	
	data.hp = 40
	data.xp_drop = 30 # temp
	
	data.connect("destroy", self, "_on_destroy")
	
func _process(delta):
	match state:
		State.GENERATING:
			spawn_time += delta
			if spawn_time >= spawn_delay:
				spawn_time = 0
				var num_spawns = randi() % max_num_spawns + min_num_spawns
				for n in range(num_spawns):
					generate_object()
			if players_in_active_area < 1 or object_in_active_area >= max_objects_in_area:
				change_state(State.RESTING)
		State.RESTING:
			if players_in_active_area >= 1 and object_in_active_area < max_objects_in_area:
				change_state(State.GENERATING)
		State.DESTROYED:
			if not is_mark_to_destroy:
				is_mark_to_destroy = true
				destroy()
	
func set_spawn_object(object):
	spawn_object = object
	emit_signal("spawn_object_changed")
	
func generate_object():
	if not spawn_object : return
	var r = rand_range(8,16)
	var x = rand_range(-r,r)
	var y = sqrt(pow(r,2) - pow(x,2))
	var object = spawn_object.instance()
	object.global_position = self.global_position + Vector2(20,0)# + Vector2(x,y)
	get_parent().add_child(object)
	
# Esta funcion es una forma segura de cambiar entre estados.
func change_state(state):
	self.state = state
	emit_signal("state_changed")
	
func damage(amount):
	if is_mark_to_destroy : return
	if $Anim.has_animation("damage"):
		$Anim.play("damage")
	data.damage(amount)
	
func destroy():
	if $Anim.has_animation("destroy"):
		$Anim.connect("animation_finished", self, "_on_destroy_animation_end")
		$Anim.play("destroy")
	else:
		queue_free()

# Esto se refiere a cuando aparece el Spawner
func spawn():
	if $Anim.has_animation("spawn"):
		$Anim.play("spawn")

func _on_ActiveArea_body_entered(body):
	if body is GPlayer:
		players_in_active_area += 1
		
func _on_ActiveArea_body_exited(body):
	if body is GPlayer:
		players_in_active_area -= 1

func _on_ObjectsArea_body_entered(body):
	if body.filename == spawn_object.resource_path:
		object_in_active_area += 1
		
func _on_ObjectsArea_body_exited(body):
	if body.filename == spawn_object.resource_path:
		object_in_active_area -= 1

func _on_DamageArea_body_entered(body):
	if body is GBullet and not is_mark_to_destroy and not is_invulnerable:
		SoundManager.play(SoundManager.Sound.HIT_1) # Por ahora usara el sonido de M
		body.dead()
		damage(1) # temp

func _on_destroy():
	change_state(State.DESTROYED)

func _on_destroy_animation_end(anim_name):
	if anim_name == "destroy":
		queue_free()