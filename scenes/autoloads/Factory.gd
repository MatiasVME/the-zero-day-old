extends Node

# Estas clases tienen metodos estaticos (Revisar)
var ItemFactory = preload("res://scenes/autoloads/Factory/ItemFactory.gd")
var PlayerFactory = preload("res://scenes/autoloads/Factory/PlayerFactory.gd")
var ItemInWorldFactory = preload("res://scenes/autoloads/Factory/ItemInWorldFactory.gd")
var ItemPackFactory = preload("res://scenes/autoloads/Factory/ItemPackFactory.gd")

# Son instancias ya que contiene variables que podrían ser estaticas
# pero GDScript no soporta variables estaticas.
var EquipmentFactory = preload("res://scenes/autoloads/Factory/EquipmentFactory.gd").new()
