class_name ShopContainer
extends Node3D


signal shop_closed
signal main_selected

@onready var shop = $Shop
@onready var camera: ShopCamera = $ShopCamera


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)


func open() -> void:
	print("opening shop...")
	camera.open_transition()


func run() -> void:
	print("running shop...")


func close() -> void:
	print("closing shop...")
	camera.close_transition()


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("shop_closed")
