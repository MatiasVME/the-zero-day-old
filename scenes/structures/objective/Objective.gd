extends Node2D

enum ObjectiveType {HIDE, IDLE, COMPLETED}
export (ObjectiveType) var objective_type = ObjectiveType.IDLE

# Numero total de jugadores que deben llegar
# al objetivo
export (int) var player_in_objetive = 1
var current_players_in_objetive = 0

var idle_objective = preload("res://scenes/structures/objective/IdleObjective.png")
var player_inside = preload("res://scenes/structures/objective/PlayerInsideObjective.png")
var completed_objective = preload("res://scenes/structures/objective/CompletedObjective.png")

onready var objectives = get_tree().get_nodes_in_group("Objective")

func _ready():
#	print(objectives)
	pass

func _on_EnterArea_body_entered(body):
	if body is GPlayer:
		current_players_in_objetive += 1
		
		if current_players_in_objetive >= player_in_objetive:
			objective_type = ObjectiveType.COMPLETED
		
		$Sprite.texture = player_inside

func _on_EnterArea_body_exited(body):
	if body is GPlayer:
		current_players_in_objetive -= 1
		
		if objective_type == ObjectiveType.COMPLETED:
			$Sprite.texture = completed_objective
		else:
			$Sprite.texture = idle_objective
			
			
			