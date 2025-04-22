class_name MainSelector
extends Node3D


func setup(callback: Callable) -> void:
	for child in get_children():
		if child is MainOption:
			child.setup()
			child.selected.connect(callback)
