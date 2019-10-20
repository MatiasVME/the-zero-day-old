extends Node2D

func _ready():
	update_display_money(false)
	
	Main.connect("store_money_updated", self, "_on_store_money_updated")
	
func update_display_money(with_anim := true):
	$Label.text = str(Main.store_money)
	
	if with_anim: $Anim.play("Update")

func _on_store_money_updated(money):
	update_display_money()