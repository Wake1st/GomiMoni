extends Node3D


@onready var main_option = $MainOption


func _ready():
	main_option.selected.connect(handle_option_selected)


func handle_option_selected(number: int) -> void:
	print("selected: %s" % number)
