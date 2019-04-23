extends Sprite

var all_button_bots := []
var bot_selected

func _ready():
	for bot in $Grid.get_children():
		all_button_bots.append(bot)
		bot.connect("toggled", self, "_on_toggled_bot", [bot])
	
	$CoreImg.play("idle")
	
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
	