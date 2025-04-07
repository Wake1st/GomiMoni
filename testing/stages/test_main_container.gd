extends Node3D


@onready var mainContainer = $MainContainer


func _ready():
	mainContainer.main_closed.connect(handle_main_closed)
	mainContainer.open()


func handle_main_closed() -> void:
	print("main is closed!")
