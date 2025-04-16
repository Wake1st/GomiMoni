class_name CancelOption
extends Button3D


signal selected


func send_selection_signal() -> void:
	emit_signal("selected")
