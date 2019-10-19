extends Node

const VERSION := "0.4.0.alpha"
const DEBUG := true

const RES_X := 420
const RES_Y := 240

var music_enable := false
var sound_enable := true

var force_mobile_mode := true
# No editar is_mobile, solo edite force_mobile si lo 
# necesita
var is_mobile := false

# Win or Lose?
enum Result {NONE, WIN, LOSE}
var result = Result.NONE

# Store
var store_money = 0

signal win_adventure
signal lose_adventure

func _ready():
	if not music_enable:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -60)
	if not sound_enable:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -60)
		
func win_adventure():
	result = Result.WIN
	emit_signal("win_adventure")
	
	get_tree().change_scene("res://scenes/hud/end_screens/EndLevel.tscn")
	
func lose_adventure():
	result = Result.LOSE
	emit_signal("lose_adventure")
	
	get_tree().change_scene("res://scenes/hud/end_screens/EndLevel.tscn")
	
func reset_store():
	store_money = 0
	
func prepare_to_exit():
	result = Result.NONE
	DataManager.get_current_player_instance().restore_hp()
	DataManager.save_all_data()
	PlayerManager.clear_players()
	get_tree().paused = false
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and PlayerManager.players.size() != 0:
		DataManager.get_current_player_instance().restore_hp()
		DataManager.save_all_data()