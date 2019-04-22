extends GStructure

func _init():
	structure_size = StructureSize.S3X3

func _ready():
	$Base.play("idle")
	
	