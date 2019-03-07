extends Node

enum Sound {
	FIRE_1,
	FIRE_2,
	HIT_1,
	MONSTER_DEAD_1,
	MONSTER_DAMAGE_1,
	MONSTER_DAMAGE_2,
	LEVEL_UP
}

func play(sound):
	if not Main.sound_enable:
		return
	
	match sound:
		Sound.FIRE_1:
			$Fire1.play()
		Sound.FIRE_2:
			$Fire2.play()
		Sound.HIT_1:
			$Hit1.play()
		Sound.MONSTER_DEAD_1:
			$MonsterDead1.play()
		Sound.MONSTER_DAMAGE_1:
			$MonsterDamage1.play()
		Sound.MONSTER_DAMAGE_2:
			$MonsterDamage2.play()
		Sound.LEVEL_UP:
			$LevelUp.play()