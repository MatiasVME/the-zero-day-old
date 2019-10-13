extends Node

var current_music

enum Music {
	PRELUDE,
	REBELS_BE,
	THE_EMPIRE,
	VICTORY
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
		Music.Victory:
			current_music = $Victory
			
	current_music.play()
	