class_name MainSelector
extends Node3D


func setup(callback: Callable) -> void:
	for child: MainOption in get_children():
		child.selected.connect(callback)
