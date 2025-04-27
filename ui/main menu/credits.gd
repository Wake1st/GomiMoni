class_name CreditsMenu
extends Node3D


@onready var cancelOption = $CancelOption
@onready var focusSystem: FocusSystem = $FocusSystem


func setup(cancelCallback: Callable) -> void:
	# connect cancel callback
	focusSystem.cancel_selected.connect(cancelCallback)
	cancelOption.selected.connect(cancelCallback)
	cancelOption.setup()
