class_name Shop
extends Node3D


const SLOTS_PER_ROW: int = 4

@onready var slotsParent: Node = $ShopSlots
@onready var boughtParent = $BoughtSlots

var shopSlots: Array[ShopSlot] = []
var boughtSlots: Array[BoughtSlot] = []

var focusedSlot: ShopSlot


func _ready():
	# setup the slots for ui control
	for child in slotsParent.get_children():
		shopSlots.push_back(child)
	for child in boughtParent.get_children():
		boughtSlots.push_back(child)


func setup() -> void:
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


func make_purchase(index: int) -> void:
	# convert indecies
	var slotIndex: int = floori(index as float / SLOTS_PER_ROW)
	
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


func check_sold_out() -> bool:
	for slot: ShopSlot in shopSlots:
		if slot.isPurchased:
			return false
	return true
