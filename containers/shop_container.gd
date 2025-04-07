class_name ShopContainer
extends Node3D


signal shop_closed(option: ShopOption.OPTIONS)

@onready var shop = $Shop
@onready var camera: ShopCamera = $ShopCamera
@onready var mainOption = $MainOption
@onready var nextOption = $NextOption

var nextScene: ShopOption.OPTIONS


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)
	mainOption.selected.connect(handle_option_selection)
	nextOption.selected.connect(handle_option_selection)


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


func handle_option_selection(option: ShopOption.OPTIONS) -> void:
	# store option
	nextOption = option
	
	# close shop either way
	close()


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("shop_closed", nextOption)
