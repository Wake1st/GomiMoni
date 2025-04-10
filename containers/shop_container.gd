class_name ShopContainer
extends Node3D


signal shop_closed(option: ShopOption.OPTIONS)

@onready var shop: Shop = $Shop
@onready var camera: ShopCamera = $ShopCamera
@onready var mainOption: ShopOption = $MainOption
@onready var nextOption: ShopOption = $NextOption
@onready var costBoard: PriceBoard = $CostBoard
@onready var moniBoard: PriceBoard = $MoniBoard

var nextSelection: ShopOption.OPTIONS


func _ready() -> void:
	# set the starting moni
	TrashData.moni = 92.01
	moniBoard.set_cost(TrashData.moni)
	
	# connect signals
	shop.item_focused.connect(handle_item_focused)
	shop.item_purchased.connect(handle_item_purchased)
	mainOption.selected.connect(handle_option_selection)
	nextOption.selected.connect(handle_option_selection)
	camera.transition_finished.connect(handle_camera_transition_finished)


func open() -> void:
	camera.open_transition()


func run() -> void:
	# if there are no more levels, disable the next button
	if LevelList.all_levels_complete():
		nextOption.visible = false
	
	# allow user to buy stuff
	UIController.isActive = true



func close() -> void:
	# dont allow user to buy
	UIController.isActive = false
	
	# start goodbye
	camera.close_transition()


func handle_item_focused(item: Trash) -> void:
	costBoard.set_cost(item.cost)


func handle_item_purchased() -> void:
	moniBoard.set_cost(TrashData.moni)


func handle_option_selection(option: ShopOption.OPTIONS) -> void:
	# store option
	nextSelection = option
	
	# close shop either way
	close()


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("shop_closed", nextSelection)
