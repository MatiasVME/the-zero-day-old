extends VBoxContainer

func _ready():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	
	for stat_name in stats.get_stat_names():
		var stat_row = load("res://scenes/hud/player_menu/skills/stats/Stat.tscn").instance()
		stat_row.stat = stat_name
		
		$StatsContainer/VBox.add_child(stat_row)
		stat_row.get_node("AddPoint").connect("pressed", self, "_on_add_point_pressed", [stat_row])
	
	update_points()

func update_points():
	var stats = DataManager.get_stats(DataManager.get_current_player())
	
	$PointsContainer/Points.text = str(stats.get_points())

func update_all():
	for stat in $StatsContainer/VBox.get_children():
		stat.update_button()
		stat.update_assigned_points()
		
	update_points()
	
func _on_add_point_pressed(stat_row):
	var stats = DataManager.get_stats(DataManager.get_current_player())
	stats.add_points_to_stat(1, stat_row.stat)
	
	update_all()