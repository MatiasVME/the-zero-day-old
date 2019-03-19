extends PHItem

class_name PHEquipment

enum EquipmentType {
	NORMAL,
	ELITE,
	INFERNAL
}
var equipment_type = EquipmentType.NORMAL

func get_str_equipment_type():
	match equipment_type:
		0: return "N"
		1: return "E"
		2: return "I"
	
	return "?"