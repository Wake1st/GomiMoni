class_name StagingSystem
extends Node3D

@onready var levelContainer: LevelContainer = $LevelContainer
@onready var shopContainer: ShopContainer = $ShopContainer
@onready var mainContainer: MainContainer = $MainContainer


func _ready() -> void:
	# connect container signals
	levelContainer.level_closed.connect(handle_level_closed)
	shopContainer.shop_closed.connect(handle_shop_closed)
	levelContainer.main_selected.connect(handle_main_selected)
	shopContainer.main_selected.connect(handle_main_selected)
	mainContainer.level_selection.connect(handle_level_selection)


func setup(levelNumber: int = -1) -> void:
	levelContainer.run(levelNumber)


func handle_level_selection(number: int) -> void:
	levelContainer.setup(number)


func handle_level_closed() -> void:
	# run the shop
	shopContainer.open()
	
	# while shop is running, swap for next level
	levelContainer.swap()


func handle_shop_closed() -> void:
	print("shop closed!")
	levelContainer.open()


func handle_main_selected() -> void:
	print("main selected")
