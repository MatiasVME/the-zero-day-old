extends Node2D

signal build_pressed()

func _ready():
	$Background/Scroll/Grid/LightTurret.build_id = BuildManager.Build.LIGHT_TURRET

func _on_LightTurret_pressed():
	BuildManager.prepare_to_build($Background/Scroll/Grid/LightTurret.build_id)