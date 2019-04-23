extends Node2D

enum StructurePanel {
	CORE
}
var current_structure

# Recibe una constante de StructurePanel
func show_panel(structure_panel):
	current_structure = structure_panel