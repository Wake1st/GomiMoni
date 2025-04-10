class_name SettingsMenu
extends Node3D


@onready var cancelOption: CancelOption = $CancelOption


func setup(cancelCallback: Callable) -> void:
	# connect cancel callback
	cancelOption.selected.connect(cancelCallback)
