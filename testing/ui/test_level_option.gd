extends Node3D


@onready var level_option: LevelOption = $LevelOption

var isEnabled: bool = false


func _ready():
	level_option.selected.connect(handle_option_selected)


func _input(_event):
	if Input.is_key_pressed(KEY_E):
		isEnabled = !isEnabled
		level_option.enable(isEnabled)


func handle_option_selected(number: int) -> void:
	print("selected: %s" % number)
