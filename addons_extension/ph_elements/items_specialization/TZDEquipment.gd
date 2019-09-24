extends TZDItem

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
	
func copy_properties(phequipment : TZDItem) -> void:
	.copy_properties(phequipment)
	equipment_type = phequipment.equipment_type
	