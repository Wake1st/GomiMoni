class_name CancelOption
extends Button3D


signal selected


func send_select_signal() -> void:
	emit_signal("selected")
