extends Node

var current_music
var vol_mus = 1.0 setget set_vol_music
var vol_sfx = 1.0 setget set_vol_sfx

enum Music {
	MAIN_THEME,
	SHOP_THEME,
	GAME_OVER,
	SPACE_BATTLE,
	REBELS_BE,
	THE_EMPIRE,
	VICTORY,
	MUSHROOMS, # ENDLEVEL
	SOLITUDE # FINAL
}

func set_vol_music(vol: float) -> void:
	AudioServer.set_bus_volume_db(1, (vol*80.0)-80.0 )

func set_vol_sfx(vol: float) -> void:
	AudioServer.set_bus_volume_db(2, (vol*80.0)-80.0 )

func play(music):
	if not Main.music_enable:
		return
	
	if current_music is AudioStreamPlayer:
		current_music.stop()
	
	match music:
		Music.MAIN_THEME:
			current_music = $MainTheme
		Music.SHOP_THEME:
			current_music = $ShopTheme
		Music.GAME_OVER:
			current_music = $GameOver
		Music.SPACE_BATTLE:
			current_music = $SpaceBattle
		Music.REBELS_BE:
			current_music = $RebelsBe
		Music.THE_EMPIRE:
			current_music = $TheEmpire
		Music.VICTORY:
			current_music = $Victory
		Music.MUSHROOMS:
			current_music = $Mushrooms
		Music.SOLITUDE:
			current_music = $Solitude
		
	current_music.play()
	