class_name Key
extends Node3D


signal triggered

@export var light: Light


func reset() -> void:
	print("WARNING: unimplemented function 'reset' in class 'Key'")


func check() -> bool:
	print("WARNING: unimplemented function 'check' in class 'Key'")
	emit_signal("triggered")
	return false
