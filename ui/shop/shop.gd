class_name Shop
extends Node3D


const SLOTS_PER_ROW: int = 4

@onready var slotsParent: Node = $ShopSlots
@onready var boughtParent = $BoughtSlots
@onready var focusSystem: ShopFocusSystem = $ShopFocusSystem

var shopSlots: Array[ShopSlot] = []
var boughtSlots: Array[BoughtSlot] = []

var focusedSlot: ShopSlot


func _ready():
	# setup the slots for ui control
	for child in slotsParent.get_children():
		shopSlots.push_back(child)
	for child in boughtParent.get_children():
		boughtSlots.push_back(child)


func setup(item_focused_callable: Callable, item_purchased_callable: Callable) -> void:
	# connect the focus signal
	focusSystem.item_focused.connect(item_focused_callable)
	
	# connect purchases
	focusSystem.item_purchased.connect(handle_purchase_made)
	focusSystem.item_purchased.connect(item_purchased_callable)
	
	# based on load data, set the purchased items to the bought slot
	for id in TrashData.purchasedItems:
		# get the correct slot
		for slotIndex in shopSlots.size():
			var slotItem = shopSlots[slotIndex].item
			if slotItem == null:
				continue
			
			if slotItem.data.id == id:
				# send to the bought slot
				move_purchase(slotIndex)
				break


func run() -> void:
	# ensure we aren't sold out
	if focusSystem.isSoldOut:
		return


func handle_purchase_made(index: int) -> void:
	# convert indecies
	var slotIndex: int = floori(index / SLOTS_PER_ROW)
	
	# move the bought item
	var purchasedItem = move_purchase(slotIndex)
	
	# store a record of purchased items
	TrashData.purchasedItems.push_back(purchasedItem.data.id)


func move_purchase(index: int) -> TrashItem:
	var purchaseSlot = shopSlots[index]
	var boughtSlot = boughtSlots[index]
	var relativePosition = purchaseSlot.get_trash_position() - boughtSlot.global_position
	var purchasedItem = purchaseSlot.remove_item()
	boughtSlot.store_item(purchasedItem, relativePosition)
	return purchasedItem
