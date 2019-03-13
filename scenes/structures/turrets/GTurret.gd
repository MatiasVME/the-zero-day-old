extends GStructure

class_name GTurret

enum State {
	SLEEP, # Dormido, no hace nada
	PATROL, # Vigilando, dependera de algunas torretas si pueden vigilar o no
	TRACK, # Busca y apunta al jugador dentro del DetectArea
	SHOOT, # Cuando dispara
	DESTROYED
}
var state : int = 0
var current_state : int = 0

# Puede recibir daño ?
#var can_damage = true

# Contiene la data, sera un PHCharacter?
# Talves no sea necesario
var data

signal state_changed

func _init():
	data = PHStructure.new()
	
# Esta funcion es una forma segura de cambiar entre estados.
func change_state(state):
	self.state = state
	self.current_state = state
	emit_signal("state_changed")

# Cuando recive daño
# Si no puede recivir daño talves tambien pueda lanzar
# una animación de invulnerabilidad - TODO
func damage(amount):
	if is_mark_to_destroy : return
	if $Anim.has_animation("damage"):
		$Anim.play("damage")
	if $Pivot/RotatorAnim.has_animation("damage"):# Animamos tambien el Rotator
		$Pivot/RotatorAnim.play("damage")
	
	data.damage(amount)

func detect():
	if is_mark_to_destroy : return
	if $Anim.has_animation("detect"):
		$Anim.play("detect")
	if $Pivot/RotatorAnim.has_animation("detect"):
		$Pivot/RotatorAnim.play("detect")

# Golpe al jugador
func shoot():
	if is_mark_to_destroy : return
	if $Anim.has_animation("shoot"):
		$Anim.play("shoot")
	if $Pivot/RotatorAnim.has_animation("shoot"):
		$Pivot/RotatorAnim.play("shoot")

func spawn():
	if $Anim.has_animation("spawn"):
		$Anim.play("spawn")

# Equivalente a Morir
func destroy():
	$Anim.connect("animation_finished", self, "_on_destroy_animation_end")
	if $Anim.has_animation("destroy"):
		$Anim.play("destroy")
	else:
		$Anim.emit_signal("animation_finished")

func _on_destroy_animation_end(anim_name):
	if anim_name == "destroy":
		queue_free()
		
	