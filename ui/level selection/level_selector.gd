class_name LevelSelector
extends Node3D


func setup(callback: Callable) -> void:
	for child: LevelOption in get_children():
		child.selected.connect(callback)


## Enables all beaten levels plus the next
func check_available_options() -> void:
	var highestAllowedLevel = LevelList.highestLevel + 1
	for child: LevelOption in get_children():
		# ensure only allowed levels are clickable
		if child.number <= highestAllowedLevel:
			child.enable(true)
