class_name CreditsMenu
extends Node3D


@onready var cancelOption: CancelOption = $CancelOption
@onready var focusSystem: FocusSystem = $FocusSystem


func setup(cancelCallback: Callable) -> void:
	# connect cancel callback
	focusSystem.cancel_selected.connect(cancelCallback)
	cancelOption.focused.connect(focusSystem.focus_on)
	cancelOption.selected.connect(cancelCallback)
	cancelOption.setup()
