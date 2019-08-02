extends HBoxContainer

var stat : String setget set_stat, get_stat

signal update_assigned_points()

func _ready():
	update_button()
	update_assigned_points()

func set_stat(stat_name : String):
	stat = stat_name
	update_img()

func get_stat():
	return stat
	
func update_img():
	match stat:
		"Vitality":
			$StatImg.texture = load("res://scenes/hud/player_menu/skills/stats/stats_images/health.png")
		"Strength":
			$StatImg.texture = load("res://scenes/hud/player_menu/skills/stats/stats_images/strength.png")
		"Luck":
			$StatImg.texture = load("res://scenes/hud/player_menu/skills/stats/stats_images/luck.png")

func update_button():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	
	if stats.get_points() > 0:
		$AddPoint.disabled = false
	else:
		$AddPoint.disabled = true
		
func update_assigned_points():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	$PointsBackground/Points.text = str(stats.get_stat_assigned_points(stat))
