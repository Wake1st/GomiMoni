class_name LevelSelector
extends Node3D


func setup(callback: Callable) -> void:
	for child: LevelOption in get_children():
		child.selected.connect(callback)
