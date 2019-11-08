# MIT License
#
# Copyright (c) 2018 - 2019 Matías Muñoz Espinoza
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# HookAchievements.gd
#

extends "Hook.gd"

class_name HookAchievements, "../icons/hook_achievements.png"

var achievements = []

signal complete_achievement(name)

func create_achievement(name, description, reward, texture_path, is_complete = false):
	var achievement = new_void_achievement()
	
	achievement["Name"] = name
	achievement["Description"] = description
	achievement["Reward"] = reward
	achievement["TexturePath"] = texture_path
	achievement["IsCompleted"] = is_complete
	
	achievements.append(achievement)

# Obtener el achievement por el nombre
func get_achievement_by_name(achievement_name):
	for i in achievements.size():
		if achievements[i]["Name"] == achievement_name:
			return achievements[i]

func complete_achievement(achievement_name):
	var achievement = get_achievement_by_name(achievement_name)
	achievement["IsCompleted"] = true
	emit_signal("complete_achievement", achievement)
	
func is_achievement_completed(achievement_name):
	var achievement = get_achievement_by_name(achievement_name)
	return achievement["IsCompleted"]

# Se obtiene el array que indica que achievements fueron completados
func get_complete_achievements_array():
	var complete_achievements = []
	
	for achievement in achievements:
		complete_achievements.append(achievement["IsCompleted"])
	
	return complete_achievements

# Se setea el array que indica que achievements fueron completados	
func set_complete_achievements_array(complete_achievements):
	for i in achievements.size():
		achievements[i]["IsCompleted"] = complete_achievements[i]
	
func new_void_achievement():
	return {
		"Name" : "",
		"Description" : "",
		"Reward" : "",
		"TexturePath" : "",
		"IsCompleted" : ""
	}
	