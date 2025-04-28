class_name ShopFocusSystem
extends Node


signal item_focused(trash: Trash)
signal item_purchased(index: int)

const FOCUS_TIME: float = 0.2
const COOLDOWN: float = 0.1
const TOTAL_ITEMS: int = 8

@onready var purchaseCooldown: Timer = $PurchaseCooldown
@export var itemRows: Array[ShopRow]
@export var buttonRow: FocusRow

var isActive: bool = false
var isSoldOut: bool = false
var focusTimer: float = FOCUS_TIME
var onCooldown: bool = false

var itemCount: int = TOTAL_ITEMS
var rowIndex: int = 0
var focusedRow: Node
var focusedElement: Node3D


func _ready() -> void:
	# connect the slots
	for slot in itemRows[0]:
		slot.mouse_focused.connect(handle_mouse_focused)
		slot.attempt_purchase.connect(handle_attempt_purchase)
	
	for slot in itemRows[1]:
		slot.mouse_focused.connect(handle_mouse_focused)
		slot.attempt_purchase.connect(handle_attempt_purchase)


func activate(value: bool = true) -> void:
	isActive = value
	
	# just start on the next button, it's easier
	focusedRow = buttonRow
	focusedElement = focusedRow.set_focus(1)


func _process(delta) -> void:
	if focusTimer > 0.0:
		focusTimer -= delta


func _input(_event) -> void:
	# ensure this system is what we want, and reduce focus timer
	if !isActive && !isSoldOut && focusTimer > 0.0:
		return
	
	# reset the focus timer
	focusTimer = FOCUS_TIME
	
	# selections override direction, in case of slight drift
	var selection = UIController.get_selection()
	var direction = UIController.get_direction()
	if selection == UIController.SELECTION.ACCEPT && focusedElement != null:
		# select and unfocus
		focusedElement.select()
		focusedElement.focus(false)
	elif direction != Vector2.ZERO:
		refocus(direction)


func get_focused_index() -> int:
	return focusedRow.focusedIndex


func set_focused_index(index: int) -> void:
	focusedRow.focusedIndex = index


func refocus(direction: Vector2) -> void:
	# first, unfocus current element
	focusedElement.focus(false)
	
	# swap rows
	if direction.y > 0:
		row_up()
	elif direction.y < 0:
		row_down()
	
	# move along rows
	if direction.x > 0:
		focusedElement = focusedRow.get_next()
	elif direction.x < 0:
		focusedElement = focusedRow.get_prev()
	
	# finally, focus on element
	focusedElement.focus()
	
	# notify container of focused item
	if focusedElement is ShopSlot:
		emit_signal("item_focused", focusedElement.item.data)


func row_down() -> void:
	# loop until we find an enabled row
	while(true):
		# ensure index does not exceed bounds
		rowIndex += 1
		if rowIndex == itemRows.size():
			rowIndex = 0
		
		# check availability
		if swap_row_focus():
			return


func row_up() -> void:
		# loop until we find an enabled row
	while(true):
		# ensure index does not exceed bounds
		rowIndex -= 1
		if rowIndex < 0:
			rowIndex = itemRows.size() - 1
		
		# check availability
		if swap_row_focus():
			return


func swap_row_focus() -> bool:
	# set new index
	var elementIndex = focusedRow.focusedIndex
	
	# last row only has two options
	if rowIndex == itemRows.size() - 1:
		elementIndex = floori(elementIndex / 2) 
	
	# if disabled, return false
	if itemRows[rowIndex].element_enabled(elementIndex):
		focusedRow = itemRows[rowIndex]
		focusedElement = focusedRow.set_focus(elementIndex)
		return true
	else:
		return false


func handle_mouse_focused(slot: ShopSlot) -> void:
	# swap focus
	focusedElement.unfocus()
	focusedElement = slot
	focusedElement.focus()
	
	# set new focus
	rowIndex = itemRows.find(focusedElement)
	focusedRow = itemRows[rowIndex]
	
	# notify container of focused item
	emit_signal("item_focused", slot.item.data)


func handle_attempt_purchase(cost: float) -> void:
	# first, make sure we aren't buying two items at once
	if onCooldown:
		return
	
	# validate Moni before purchase
	if cost < TrashData.moni:
		# ensure no other items are purchased during this cycle
		onCooldown = true
		
		# charge user
		TrashData.moni -= cost
		
		# notify container of purchase
		emit_signal("item_purchased", focusedElement.focusedIndex)
		
		# shift to a new focus
		refocus(Vector2(1,0))
		
		# start cooldown timer
		purchaseCooldown.start(COOLDOWN)


func _on_purchase_cooldown_timeout():
	onCooldown = false
