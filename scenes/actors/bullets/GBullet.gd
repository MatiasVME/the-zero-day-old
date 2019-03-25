extends KinematicBody2D

class_name GBullet

enum Trajectory {
	LINEAL,
	SEEKER
}
var trajectory = Trajectory.LINEAL
#var origin : Vector2
var direction : Vector2

# El que dispara las balas le dice a la bala cuanto daño
# hace, por ejemplo. Una torreta dispara y le asigna
# 2 de daño a la bala y la bala cuando choca con el
# player le hace 2 de daño.
var damage := 1

# Previene que se haga la animacion de dead mas
# de una vez.
var is_mark_to_dead := false

var collision
var collision_count := 0

onready var terrain = get_tree().get_nodes_in_group("Terrain")

func _ready():
	$Sprite.playing = true
	
	if terrain.size() > 0:
		print("terrain: ", terrain)
		add_collision_exception_with(terrain[0].tile_set)

func _physics_process(delta):
	if trajectory == Trajectory.LINEAL:
		move_and_slide(direction * 250)
	
	collision_count = get_slide_count()
	
	if not is_mark_to_dead and collision_count > 0:
		for i in collision_count:
			collision = get_slide_collision(i)
			if collision.collider.is_in_group("Terrain") or collision.collider.is_in_group("Enviroment"):
				dead()
	
func dead():
	if not is_mark_to_dead:
		is_mark_to_dead = true
		$HitWall.play()
		$Anim.play("dead")

func _on_TimeToDead_timeout():
	if not is_mark_to_dead:
		dead()

func _on_Anim_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()
