class_name LevelSelector
extends Node3D


@onready var options = $Options
@onready var cancelOption: CancelOption = $CancelOption
@onready var focusSystem: FocusSystem = $FocusSystem


func setup(cancelCallable: Callable, levelCallable: Callable) -> void:
	# connect cancel callback
	focusSystem.cancel_selected.connect(cancelCallable)
	cancelOption.focused.connect(focusSystem.focus_on)
	cancelOption.selected.connect(cancelCallable)
	cancelOption.setup()
	
	# connect level selection callback
	for child: LevelOption in options.get_children():
		child.setup()
		child.focused.connect(focusSystem.focus_on)
		child.selected.connect(levelCallable)


## Enables all beaten levels plus the next
func check_available_options() -> void:
	var highestAllowedLevel = LevelList.highest_allowed_index()
	for child: LevelOption in options.get_children():
		# ensure only allowed levels are clickable
		if child.number <= highestAllowedLevel:
			child.enable(true)
