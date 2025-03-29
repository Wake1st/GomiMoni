class_name ShopContainer
extends Node3D


signal shop_closed
signal main_selected

@onready var shop = $Shop


func open() -> void:
	print("shop open!")


func close() -> void:
	print("closing shop")
	emit_signal("shop_closed")
