extends Node

const VERSION := "0.3.0.alpha"
const DEBUG := false

var music_enable := true
var sound_enable := true

const RES_X := 360
const RES_Y := 240

# Almacenamiento de data temporal par el
# final de nivel
var store_iron_earned := 0
var store_titanium_earned := 0
var store_steel_earned := 0
var store_ruby_earned := 0

# Win or Lose?
enum Result {NONE, WIN, LOSE}
var result = Result.NONE

signal win_adventure
signal lose_adventure

func win_adventure():
	result = Result.WIN
	emit_signal("win_adventure")
	
func lose_adventure():
	result = Result.LOSE
	emit_signal("lose_adventure")
	
func reset_store():
	store_iron_earned = 0
	store_titanium_earned = 0
	store_steel_earned = 0
	store_ruby_earned = 0
	
func prepare_to_exit():
	result = Result.NONE
	DataManager.get_current_player_instance().restore_hp()
	DataManager.save_all_data()
	PlayerManager.clear_players()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and PlayerManager.players.size() != 0:
		DataManager.get_current_player_instance().restore_hp()
		DataManager.save_all_data()
#		prepare_to_exit()
#		print("get_current_player",