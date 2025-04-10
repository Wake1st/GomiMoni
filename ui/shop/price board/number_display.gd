class_name NumberDisplay
extends MeshInstance3D


func set_number(number: int) -> void:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = NumberMeshes.get_mesh(number)
	set_surface_override_material(0, material)
