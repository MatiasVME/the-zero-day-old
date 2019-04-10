extends Node2D

func _ready():	
	var stats = DataManager.get_stats(DataManager.get_current_player())
	var stat_names = stats.get_stat_names()
	
	for stat_name in stat_names:
		var stat_row = load("res://scenes/hud/stats/Stat.tscn").instance()
		stat_row.stat = stat_name
		
		$StatsContainer/VBox.add_child(stat_row)
		stat_row.connect("update_assigned_points", self, "_on_update_assigned_points")
	
	update_points()

func update_points():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	
	$PointsContainer/Points.text = str(stats.get_points())

func update_all():
	update_points()
	
	for stat in $StatsContainer/VBox.get_children():
		stat.update_button()
		stat.update_assigned_points()
	
	print("update??-2")
	
func _on_update_assigned_points():
	update_points()
	
	
	
	