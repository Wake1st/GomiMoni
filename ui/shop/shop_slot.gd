class_name ShopSlot
extends Node3D


var item: Trash


func add_trash(trash: Trash) -> void:
	item = trash
	add_child(trash)
	trash.global_position = global_position


func focus() -> void:
	print("focused on: %s" % item.name)


func unfocus() -> void:
	print("focused off: %s" % item.name)
