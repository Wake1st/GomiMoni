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


func handle_level_closed(passed: bool) -> void:
	if passed:
		# run the shop
		shopContainer.open()
		
		# while shop is running, swap for next level
		levelContainer.swap()
	else:
		# return to menu if not passed
		mainContainer.open()
		
		# remove the current level
		levelContainer.teardown()



func handle_shop_closed(option: ShopOption.OPTIONS) -> void:
	match option:
		ShopOption.OPTIONS.NEXT:
			# move onto the next level
			levelContainer.open()
		ShopOption.OPTIONS.MAIN:
			# return to the main area
			mainContainer.open()
			
			# deconstruct the last played level
			levelContainer.teardown()


func check_to_launch_level() -> void:
	if isLevelReady && isMainClosed:
		levelContainer.open()
		
		# reset checking values
		isLevelReady = false
		isMainClosed = false
