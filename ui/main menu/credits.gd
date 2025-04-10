class_name CreditsMenu
extends Node3D


@onready var cancelOption = $CancelOption


func setup(cancelCallback: Callable) -> void:
	# connect cancel callback
	cancelOption.selected.connect(cancelCallback)
