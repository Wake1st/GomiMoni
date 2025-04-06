class_name LevelSelector
extends Node3D


func setup(callback: Callable) -> void:
	var highestAllowedLevel = LevelList.highestLevel + 1
	for child: LevelOption in get_children():
		# pass selection signal
		child.selected.connect(callback)
		
		# ensure only allowed levels are clickable
		if child.number <= highestAllowedLevel:
			child.enable(true)
