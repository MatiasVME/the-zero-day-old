extends Control

class_name Avatar

func _ready():
	PlayerManager.connect("player_gain_hp", self, "_on_player_gain_hp")
	PlayerManager.connect("player_get_damage", self, "_on_player_get_damage")
	PlayerManager.connect("player_gain_xp", self, "_on_player_gain_xp")
	PlayerManager.connect("player_level_up", self, "_on_player_level_up")
	
func set_avatar_actor(avatar_actor):
	$HealthBar.value = avatar_actor.data.hp
	$HealthBar.max_value = avatar_actor.data.max_hp
	
	$Level.text = str(avatar_actor.data.level)
	
	$XPBar.value = avatar_actor.data.xp
	$XPBar.max_value = avatar_actor.data.xp_required
	
func _on_player_gain_hp(player, hp):
	$HealthBar.value = player.data.hp
	
func _on_player_get_damage(player, damage):
	$HealthBar.value = player.data.hp
	
func _on_player_gain_xp(player, xp):
	$XPBar.value = player.data.xp
	$XPBar.max_value = player.data.xp_required
	
func _on_player_level_up(player, new_level):
	$HealthBar.max_value = player.data.max_hp
	$Level.text = str(new_level)
	