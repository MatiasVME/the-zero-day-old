extends Node2D

signal build_pressed()

func _ready():
#	$Background/Grid/LightTurret.build_id = Enums.StructureType.LIGHT_TURRET
	pass
	
func _on_CF_pressed():
	BuildManager.prepare_to_build(Enums.StructureType.COMMON_FACTORY)
