class_name ShopOption
extends Button3D


enum OPTIONS {
	NEXT,
	MAIN
}

signal selected(option: OPTIONS)

@export var option: OPTIONS


func send_select_signal() -> void:
	emit_signal("selected", option)
