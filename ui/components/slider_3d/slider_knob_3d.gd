class_name SliderKnob3D
extends StaticBody3D


const LIGHT_BLUE = preload("res://assets/materials/light_blue.tres")
const HEAVY = preload("res://assets/materials/heavy.tres")

@onready var mesh: MeshInstance3D = $MeshInstance3D


func highlight(value: bool = true) -> void:
	if value:
		mesh.set_surface_override_material(0, HEAVY.duplicate())
	else:
		mesh.set_surface_override_material(0, LIGHT_BLUE.duplicate())
