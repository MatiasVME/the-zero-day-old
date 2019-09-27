extends TZDItem

class_name TZDEquipment

enum EquipmentType {
	NORMAL,
	ELITE,
	SUPREME
}
var equipment_type = EquipmentType.NORMAL

func get_str_equipment_type():
	match equipment_type:
		0: return "N"
		1: return "E"
		2: return "S"

	return "?"
	