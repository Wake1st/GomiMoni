class_name Shop
extends Node3D


signal item_focused(trash: Trash)
signal item_purchased

const SLOTS_PER_ROW: int = 4
const FOCUS_TIME: float = 0.2

@onready var slotsParent: Node = $ShopSlots
@onready var boughtParent = $BoughtSlots

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
		slot.mouse_focused.connect(handle_mouse_focused)
		slot.attempt_purchase.connect(handle_attempt_purchase)
	
	# set initial focus
	focusedSlot = shopSlots[0]
	focusedSlot.focus()
	
	# set number of items for sale
	itemCount = shopSlots.size()


func _process(delta):
	# ensure the player cannot interact when inactive
	# or if all items are sold out
	if !UIController.isActive || isSoldOut:
		return
	
	# reduce focus timer
	if focusTimer > 0.0:
		focusTimer -= delta
	
	# attempt to focus on new trash
	var uiDirection = UIController.get_direction()
	if uiDirection != Vector2.ZERO and focusTimer < 0.0:
		refocus(uiDirection)
		
		# reset the focus timer
		focusTimer = FOCUS_TIME


func handle_mouse_focused(slot: ShopSlot) -> void:
	# swap focus
	focusedSlot.unfocus()
	focusedSlot = slot
	focusedSlot.focus()
	
	# set new index
	focusedIndex = shopSlots.find(slot)
	
	# notify container of focused item
	emit_signal("item_focused", slot.item.data)


func handle_attempt_purchase(cost: float) -> void:
	# validate Moni before purchase
	if cost < TrashData.moni:
		# charge user
		TrashData.moni -= cost
		
		# move the bought item
		var boughtSlot = boughtSlots[focusedIndex]
		var relativePosition = focusedSlot.get_trash_position() - boughtSlot.global_position
		var purchasedItem = focusedSlot.remove_item()
		boughtSlot.store_item(purchasedItem, relativePosition)
		
		# store a record of purchased items
		TrashData.purchased_items.push_back(purchasedItem.data)
		
		# notify container of purchase
		emit_signal("item_purchased")
		
		# shift to a new focus
		refocus(Vector2(1,0), true)


func refocus(direction: Vector2, isPurchased: bool = false) -> void:
	# iterate index
	set_next_valid_index(direction)
	
	# swap focus
	swap_index(isPurchased)


func set_next_valid_index(direction: Vector2) -> void:
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


func swap_index(isPurchased: bool) -> void:
	if !isPurchased:
		focusedSlot.unfocus()
	focusedSlot = shopSlots[focusedIndex]
	focusedSlot.focus()
	
	# notify container of focused item
	emit_signal("item_focused", focusedSlot.item.data)
