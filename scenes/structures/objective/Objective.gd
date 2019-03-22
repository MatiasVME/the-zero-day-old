extends Node2D

enum ObjectiveStatus {HIDE, IDLE, COMPLETED}
export (ObjectiveStatus) var objective_status = ObjectiveStatus.IDLE

# Numero total de jugadores que deben llegar
# al objetivo
export (int) var player_in_objetive := 1
var current_players_in_objetive := 0

export (bool) var is_final_objective := false
export (bool) var is_optional_objective := false

var idle_objective = preload("res://scenes/structures/objective/IdleObjective.png")
var player_inside = preload("res://scenes/structures/objective/PlayerInsideObjective.png")
var completed_objective = preload("res://scenes/structures/objective/CompletedObjective.png")

onready var objectives = get_tree().get_nodes_in_group("Objective")

func _ready():
#	print(objectives)
	pass

func have_you_won():
	var won = false
	var objectives_to_won = objectives.size()
	var current_objectives = 0
	
	var i := 0
	while (i < objectives_to_won):
		if objectives[i].is_optional:
			objectives_to_won -= 1
		elif objectives[i].objective_status == ObjectiveStatus.COMPLETED:
			current_objectives += 1
		
		i += 1
		
	if current_objectives == objectives_to_won:
#		Main.win()
		pass
	
func _on_EnterArea_body_entered(body):
	if body is GPlayer:
		current_players_in_objetive += 1
		
		if current_players_in_objetive >= player_in_objetive:
			objective_status = ObjectiveStatus.COMPLETED
		
		$Sprite.texture = player_inside

func _on_EnterArea_body_exited(body):
	if body is GPlayer:
		current_players_in_objetive -= 1
		
		if objective_status == ObjectiveStatus.COMPLETED:
			$Sprite.texture = completed_objective
		else:
			$Sprite.texture = idle_objective
			
			
			