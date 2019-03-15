"""
PHItem.gd (Project Humanity Item)

Es una extencion y adaptacion del plugin RPGElements en especifico,
de RPGItem.

PHItem se encarga de administrar la logica y la informacion,
que contienen los items.
"""

extends RPGItem

class_name PHItem

var unique_id : String

func _init():
	randomize()
	unique_id = str(OS.get_unix_time(), "-", randi())
#	print("unique_id: ", unique_id)