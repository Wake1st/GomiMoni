class_name StagingSystem
extends Node3D

@onready var levelContainer: LevelContainer = $LevelContainer
@onready var shopContainer: ShopContainer = $ShopContainer


func _ready() -> void:
	# connect container signals
	levelContainer.level_closed.connect(handle_level_closed)
	shopContainer.shop_closed.connect(handle_shop_closed)
	levelContainer.main_selected.connect(handle_main_selected)
	shopContainer.main_selected.connect(handle_main_selected)


func setup(levelNumber: int = -1) -> void:
	levelContainer.run(levelNumber)


func handle_level_closed() -> void:
	print("level closed!")
	shopContainer.open()


func handle_shop_closed() -> void:
	print("shop closed!")
	levelContainer.open()


func handle_main_selected() -> void:
	print("main selected")
