extends Node

var current_music

enum Music {
	PRELUDE,
	REBELS_BE,
	THE_EMPIRE,
	VICTORY,
	END_LEVEL
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
		Music.END_LEVEL:
			current_music = $EndLevel
			
	current_music.play()
	