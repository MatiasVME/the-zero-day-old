extends Node2D

var point_sprite = load("res://scenes/autoloads/TestHelper/Point.tscn")

var test_instances = {}

var last_id = -1

func new_test_point_instance():
	last_id += 1
	
	test_instances[last_id] = point_sprite.instance()
	
	add_child(test_instances[last_id])
	
	return last_id

func get_test_instance(id):
	return test_instances[id]
	
	

