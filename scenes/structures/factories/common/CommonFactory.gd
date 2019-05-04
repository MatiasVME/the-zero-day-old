extends GStructure

func _init():
	structure_size = Enums.StructureSize.S2X2

func _ready():
	$Base.play("default")