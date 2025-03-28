class_name Shop
extends Node3D


const SLOTS_PER_ROW: int = 4
const BUMP_TIME: float = 0.2

@onready var trashScene = preload("res://ui/shop/trash.tscn")
@onready var slotsParent: Node = $ShopSlots

var trashItems: Array[Trash] = []
var shopSlots: Array[ShopSlot] = []

var focusedIndex: int = 0
var focusedSlot: ShopSlot
var bumpTimer: float = BUMP_TIME


func _ready():
	# setup the slots for ui control
	for child in slotsParent.get_children():
		shopSlots.push_back(child)
	
	# fill the slots with trash
	for slot in shopSlots:
		var trash: Trash = trashScene.instantiate()
		trashItems.push_back(trash)
		slot.add_trash(trash)
	
	# set initial focus
	focusedSlot = shopSlots[0]
	focusedSlot.focus()


func _process(delta):
	var ui_selection = UIController.get_selection()
	if ui_selection == UIController.SELECTION.ACCEPT:
		# do acceptance
		pass
	elif ui_selection == UIController.SELECTION.CANCEL:
		# do cancel
		pass
	
	# reduce bump time
	if bumpTimer > 0.0:
		bumpTimer -= delta
	
	# check focus
	var ui_direction = UIController.get_direction()
	if ui_direction != Vector2.ZERO and bumpTimer < 0.0:
		# set new index
		focusedIndex += ui_direction.x
		focusedIndex -= ui_direction.y * SLOTS_PER_ROW
		focusedIndex %= shopSlots.size()
		
		# swap focus
		focusedSlot.unfocus()
		focusedSlot = shopSlots[focusedIndex]
		focusedSlot.focus()
		
		# reset the bump timer
		bumpTimer = BUMP_TIME
