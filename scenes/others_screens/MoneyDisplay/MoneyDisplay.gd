extends Sprite

var SPEED = 1

var to_show = 0.0
var current_amount = 0.0
var step = 0.0

var delta_step := 0

func _ready():
	set_process(false)

func _process(delta):
	if to_show <= current_amount:
		$Money.text = "+" + str(int(round(to_show)))
		set_process(false)
		return
	
	if delta_step % SPEED == 0:
		current_amount += step
		$Money.text = "+" + str(int(round(current_amount)))
	else:
		if delta_step == SPEED: delta_step == 0
	
	delta_step += 1

func amount_to_show(amount):
	to_show = amount
	step = to_show / 100
	
	set_process(true)
	$Anim.play("Show")