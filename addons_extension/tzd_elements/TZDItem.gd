"""
TZDItem.gd (The Zero Day Item)

Es una extencion y adaptacion del plugin RPGElements en especifico,
de RPGItem.

TZDItem se encarga de administrar la logica y la informacion,
que contienen los items.
"""

extends RPGItem

class_name TZDItem

#var unique_id : String
#
#func _init():
#	randomize()
#	unique_id = str(OS.get_unix_time(), "-", randi())
	
#func copy_properties(phitem : TZDItem) -> void:
#	set_item_name(phitem.item_name)
#	set_desc(phitem.desc)
#	amount = phitem.amount
#	set_buy_price(phitem.buy_price)
#	set_sell_price(phitem.sell_price)
#	set_texture_path(phitem.texture_path)
#	set_extra_data(phitem.extra_data)
#	set_weight(phitem.weight)
#	stack_max = phitem.stack_max
#	atributes = phitem.atributes.duplicate()