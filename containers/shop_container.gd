class_name ShopContainer
extends Node3D


signal shop_closed(option: ShopOption.OPTIONS)

const MUSIC_FADE_DURATION: float = 0.6

@onready var shop: Shop = $Shop
@onready var camera: ShopCamera = $ShopCamera

@onready var mainOption: ShopOption = $MainOption
@onready var nextOption: ShopOption = $NextOption
@onready var costBoard: PriceBoard = $CostBoard
@onready var moniBoard: PriceBoard = $MoniBoard

@onready var focusSystem: ShopFocusSystem = $ShopFocusSystem
@onready var musicPlayer: MusicPlayer = $MusicPlayer
@onready var buttonSFX: AudioStreamPlayer = $ButtonSFX
@onready var purchaseSFX: AudioStreamPlayer = $PurchaseSFX

var nextSelection: ShopOption.OPTIONS


func _ready() -> void:
	# connect signals
	mainOption.selected.connect(handle_option_selection)
	nextOption.selected.connect(handle_option_selection)
	camera.transition_finished.connect(handle_camera_transition_finished)
	focusSystem.item_focused.connect(handle_item_focused)
	focusSystem.item_purchased.connect(handle_item_purchased)


func setup() -> void:
	shop.setup()
	focusSystem.setup()


func open() -> void:
	# start hello
	camera.open_transition()
	musicPlayer.fade_in(MUSIC_FADE_DURATION)
	
	# if there are no more levels, disable the next button
	nextOption.visible = !LevelList.past_final_level()


func run() -> void:
	# set the starting moni
	moniBoard.set_cost(TrashData.moni)
	
	# allow user to buy stuff
	UIController.isActive = true
	
	# set the state
	StageState.currentState = StageState.STAGES.SHOP
	
	# activate the focus
	focusSystem.activate()


func close() -> void:
	# dont allow user to buy
	UIController.isActive = false
	
	# start goodbye
	camera.close_transition()
	musicPlayer.fade_out(MUSIC_FADE_DURATION)
	
	# ensure the focus system is off
	focusSystem.activate(false)


func handle_item_focused(item: Trash) -> void:
	costBoard.set_cost(item.cost)


func handle_item_purchased(index: int) -> void:
	# purchase effects
	shop.make_purchase(index)
	moniBoard.set_cost(TrashData.moni)
	purchaseSFX.play()
	
	# check for sold out
	focusSystem.isSoldOut = shop.check_sold_out()


func handle_option_selection(option: ShopOption.OPTIONS) -> void:
	# only allow if active
	if !focusSystem.isActive:
		return
	
	# store option
	nextSelection = option
	
	# close shop either way
	close()
	
	# play the button sfx
	buttonSFX.play()


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("shop_closed", nextSelection)
