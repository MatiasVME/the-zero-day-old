extends Sprite

var all_button_bots := []
var bot_selected

signal take_off_player(player_name)

func _ready():
	# Conectar los botones
	for bot in $Grid.get_children():
		all_button_bots.append(bot)
		bot.connect("toggled", self, "_on_toggled_bot", [bot])
	
	# Activar animacion de la imagen del core
	$CoreImg.play("idle")
	
	# Activar los botones de los jugadores
	for button in $Grid.get_children():
		if PlayerManager.name_of_available_players.has(button.name):
			button.disabled = false
	
func disable_all_bot_buttons(button_exception = null):
	for button in all_button_bots:
		if button_exception and button == button_exception: continue
		button.pressed = false

func _on_toggled_bot(button_pressed, bot):
	if button_pressed:
		disable_all_bot_buttons(bot)
		bot_selected = bot
		$OkBots.disabled = false
	else:
		bot_selected = null
		$OkBots.disabled = true
	
func _on_OkBots_pressed():
	disable_all_bot_buttons()
	
	bot_selected.self_modulate = Color("64ffffff")
	bot_selected.disabled = true
	
	StructurePanelManager.hide_panel()
#	emit_signal("take_off_player", bot_selected.name)