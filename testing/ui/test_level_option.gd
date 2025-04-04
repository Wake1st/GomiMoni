extends Node3D


@onready var level_option: LevelOption = $LevelOption


func _ready():
	level_option.selected.connect(handle_option_selected)


func handle_option_selected(number: int) -> void:
	print("selected: %s" % number)
