extends Node

enum Sound {
	HIT_1,
}

func play_sound(sound):
	match sound:
		Sound.HIT_1:
			$Hit1.play()