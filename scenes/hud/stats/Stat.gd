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
			$StatImg.texture = load("res://scenes/hud/stats/stats_images/Vitality.png")
		"Strength":
			$StatImg.texture = load("res://scenes/hud/stats/stats_images/Strength.png")
		"Luck":
			$StatImg.texture = load("res://scenes/hud/stats/stats_images/Luck.png")

func update_button():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	
	if stats.get_points() > 0:
		$AddPoint.disabled = false
	else:
		$AddPoint.disabled = true
		
	update_assigned_points()
		
func update_assigned_points():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	$PointsBackground/Points.text = str(stats.get_stat_assigned_points(stat))
	
	emit_signal("update_assigned_points")
	
func _on_AddPoint_pressed():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	stats.add_points_to_stat(1, stat)
	update_button()
