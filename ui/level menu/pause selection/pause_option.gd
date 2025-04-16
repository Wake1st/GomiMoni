class_name PauseOption
extends Button3D


enum OPTIONS {
	RETURN,
	RESET,
	LEAVE
}

signal selected(option: OPTIONS)

@export var option: OPTIONS


func send_select_signal() -> void:
	emit_signal("selected", option)
