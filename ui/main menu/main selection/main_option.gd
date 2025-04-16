class_name MainOption
extends Button3D


enum OPTIONS {
	LEVELS,
	SETTINGS,
	CREDITS
}

signal selected(option: OPTIONS)

@export var option: OPTIONS

func send_select_signal() -> void:
	emit_signal("selected", option)
