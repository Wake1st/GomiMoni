class_name Shop
extends Node3D


const SLOTS_PER_ROW: int = 4
const FOCUS_TIME: float = 0.2

@onready var trashScene = preload("res://ui/shop/trash.tscn")
@onready var slotsParent: Node = $ShopSlots
@onready var boughtParent = $BoughtSlots

var trashItems: Array[Trash] = []
var shopSlots: Array[ShopSlot] = []
var boughtSlots: Array[BoughtSlot] = []

var focusedIndex: int = 0
var focusedSlot: ShopSlot
var focusTimer: float = FOCUS_TIME

var itemCount: int
var isSoldOut: bool = false


func _ready():
	# setup the slots for ui control
	for child in slotsParent.get_children():
		shopSlots.push_back(child)
	for child in boughtParent.get_children():
		boughtSlots.push_back(child)
	
	# fill the slots with trash
	for slot in shopSlots:
		var trash: Trash = trashScene.instantiate()
		trashItems.push_back(trash)
		slot.add_trash(trash)
	
	# set initial focus
	focusedSlot = shopSlots[0]
	focusedSlot.focus()
	
	# set number of items for sale
	itemCount = shopSlots.size()


func _process(delta):
	# ensure the player cannot interact when inactive
	if !UIController.isActive:
		return
	
	var uiSelection = UIController.get_selection()
	if uiSelection == UIController.SELECTION.CANCEL:
		# do cancel
		pass
	
	# before any interactions, check the store inventory
	if isSoldOut:
		return
	
	# attempt a trash purchase
	if uiSelection == UIController.SELECTION.ACCEPT:
		# TODO: validate Moni before purchase
		
		# move the bought item
		var boughtSlot = boughtSlots[focusedIndex]
		var relativePosition = focusedSlot.get_trash_position() - boughtSlot.global_position
		boughtSlot.store_item(focusedSlot.remove_trash(), relativePosition)
		
		# shift to a new focus
		refocus(Vector2(1,0), true)
	
	# reduce focus timer
	if focusTimer > 0.0:
		focusTimer -= delta
	
	# attempt to focus on new trash
	var uiDirection = UIController.get_direction()
	if uiDirection != Vector2.ZERO and focusTimer < 0.0:
		refocus(uiDirection)
		
		# reset the focus timer
		focusTimer = FOCUS_TIME


func refocus(direction: Vector2, isPurchased: bool = false) -> void:
	# iterate index
	var slotsChecked: int = 0
	while(true):
		if slotsChecked < itemCount:
			slotsChecked += 1
		else:
			isSoldOut = true
			return
		
		focusedIndex += (direction.x as int)
		focusedIndex -= (direction.y as int) * SLOTS_PER_ROW
		focusedIndex %= shopSlots.size()
		
		if !shopSlots[focusedIndex].is_empty():
			break
	
	# swap focus
	if !isPurchased:
		focusedSlot.unfocus()
	focusedSlot = shopSlots[focusedIndex]
	focusedSlot.focus()
