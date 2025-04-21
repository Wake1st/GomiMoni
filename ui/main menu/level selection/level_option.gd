class_name LevelOption
extends Button3D


signal selected(number: int)

@export_range(0, 5) var number: int = 0


func send_select_signal() -> void:
	emit_signal("selected", number)


func enable(value: bool) -> void:
	enabled = value
