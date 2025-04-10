class_name NumberMeshes


static var meshes: Dictionary = {
	0: preload("res://assets/images/currency textures/0.png"),
	1: preload("res://assets/images/currency textures/1.png"),
	2: preload("res://assets/images/currency textures/2.png"),
	3: preload("res://assets/images/currency textures/3.png"),
	4: preload("res://assets/images/currency textures/4.png"),
	5: preload("res://assets/images/currency textures/5.png"),
	6: preload("res://assets/images/currency textures/6.png"),
	7: preload("res://assets/images/currency textures/7.png"),
	8: preload("res://assets/images/currency textures/8.png"),
	9: preload("res://assets/images/currency textures/9.png")
}


static func get_mesh(number: int) -> Texture2D:
	return meshes[number]
