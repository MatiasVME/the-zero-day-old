extends Node2D

# Contiene toda la información del player o actor
var current_actor : GActor

func update_money():
	$VBox/CenterContainer/HBoxContainer/VBoxContainer/Money/Money.text = str(DataManager.data_user["Money"])

func update_hp():
	if current_actor:
		$VBox/CenterContainer/HBoxContainer/VBoxContainer/HPHPMAX/HPHPMAX.text = str(current_actor.data.hp) + "/" + str(current_actor.data.max_hp)
	else:
		print("No existe current_player")
	
func update_xp():
	if current_actor:
		$VBox/CenterContainer/HBoxContainer/VBoxContainer/XP/XP.text = str(current_actor.data.xp) + "/" + str(current_actor.data.xp_required)
	else:
		print("No existe current_player")
	
func update_all():
	update_money()
	update_hp()
	update_xp()

func set_current_actor(actor : GActor):
	current_actor = actor
	
	# Temp: Luego hay que mejorarlo
	$VBox/MarginContainer/Avatars/HBox/Avatar.add_avatar_actor(current_actor)

