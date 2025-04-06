class_name StagingSystem
extends Node3D

@onready var levelContainer: LevelContainer = $LevelContainer
@onready var shopContainer: ShopContainer = $ShopContainer
@onready var mainContainer: MainContainer = $MainContainer

var isMainClosed: bool = false
var isLevelReady: bool = false


func _ready() -> void:
	# connect container signals
	mainContainer.level_selection.connect(handle_level_selection)
	mainContainer.main_closed.connect(handle_main_closed)
	levelContainer.level_ready.connect(handle_level_ready)
	levelContainer.level_closed.connect(handle_level_closed)
	shopContainer.shop_closed.connect(handle_shop_closed)


func setup() -> void:
	mainContainer.open()


func handle_level_selection(number: int) -> void:
	levelContainer.setup(number)


func handle_level_ready() -> void:
	isLevelReady = true
	check_to_launch_level()


func handle_main_closed() -> void:
	isMainClosed = true
	check_to_launch_level()


func handle_level_closed() -> void:
	# run the shop
	shopContainer.open()
	
	# while shop is running, swap for next level
	levelContainer.swap()


func handle_shop_closed(option: ShopOption.OPTIONS) -> void:
	match option:
		ShopOption.OPTIONS.NEXT:
			levelContainer.open()
		ShopOption.OPTIONS.MAIN:
			mainContainer.open()


func check_to_launch_level() -> void:
	if isLevelReady && isMainClosed:
		levelContainer.open()
		
		# reset checking values
		isLevelReady = false
		isMainClosed = false
