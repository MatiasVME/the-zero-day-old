extends Node

const ADVENTURE_LEVEL_MAX = 2

# Nivel máximo actual (nivel máximo pasado)
var current_maximum_level = 1

var current_level = 1

func get_level(level_num):
	match level_num:
		1 : return "res://scenes/maps/adventure_mode/main_history/chapter_1/level_01/StageFull-Start.tscn"
		2 : return "res://scenes/maps/adventure_mode/main_history/chapter_1/level_02/StageFull-Start.tscn"