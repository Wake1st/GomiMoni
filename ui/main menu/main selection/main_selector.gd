class_name MainSelector
extends Node3D


@onready var exitOption = $ExitOption
@onready var focusSystem: FocusSystem = $FocusSystem


func _ready() -> void:
	if OS.has_feature("web"):
		exitOption.visible = false
		exitOption.enabled = false


func setup(selectedCallable: Callable) -> void:
	for child in get_children():
		if child is MainOption:
			child.setup()
			child.focused.connect(focusSystem.focus_on)
			child.selected.connect(selectedCallable)
