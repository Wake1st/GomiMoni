class_name LevelSelector
extends Node3D


@onready var options = $Options
@onready var cancelOption: CancelOption = $CancelOption


func setup(cancelCallback: Callable, levelCallback: Callable) -> void:
	# connect cancel callback
	cancelOption.selected.connect(cancelCallback)
	
	# connect level selection callback
	for child: LevelOption in options.get_children():
		child.selected.connect(levelCallback)


## Enables all beaten levels plus the next
func check_available_options() -> void:
	var highestAllowedLevel = LevelList.highestLevel + 1
	for child: LevelOption in options.get_children():
		# ensure only allowed levels are clickable
		if child.number <= highestAllowedLevel:
			child.enable(true)
