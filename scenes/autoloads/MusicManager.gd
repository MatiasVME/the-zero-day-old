extends Node

var current_music

enum Music {
	PRELUDE,
	REBELS_BE,
	THE_EMPIRE,
	VICTORY,
	MUSHROOMS, # ENDLEVEL
	SOLITUDE # FINAL
}

func play(music):
	if not Main.music_enable:
		return
	
	if current_music is AudioStreamPlayer:
		current_music.stop()
	
	match music:
		Music.PRELUDE:
			current_music = $Prelude
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
	