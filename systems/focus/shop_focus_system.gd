class_name ShopFocusSystem
extends Node


signal item_focused(trash: Trash)
signal item_purchased(index: int)

const SLOTS_PER_ROW: int = 4
const TOTAL_ITEMS: int = 8
const COOLDOWN: float = 0.2

@onready var cooldown: Timer = $Cooldown
@export var itemRows: Array[ShopRow]
@export var buttonRow: FocusRow

var isActive: bool = false
var isSoldOut: bool = false

var itemCount: int = TOTAL_ITEMS
var rowIndex: int = 0
var focusedRow: Node
var focusedElement: Node3D


func setup() -> void:
	# connect the slots
	for slot in itemRows[0].elements:
		slot.mouse_focused.connect(handle_mouse_focused)
		slot.attempt_purchase.connect(handle_attempt_purchase)
	
	for slot in itemRows[1].elements:
		slot.mouse_focused.connect(handle_mouse_focused)
		slot.attempt_purchase.connect(handle_attempt_purchase)
	
	for button: Button3D in buttonRow.elements:
		button.focused.connect(handle_button_focused)
	
	focusedRow = buttonRow
	focusedElement = focusedRow.set_focus(1)


func activate(value: bool = true) -> void:
	isActive = value
	
	# just start on the next button, it's easier
	focusedElement.focus(false)
	focusedRow = buttonRow
	focusedElement = focusedRow.set_focus(1)
	focusedElement.focus(isActive)


func _input(_event) -> void:
	# ensure this system is what we want, and reduce focus timer
	if !isActive && !isSoldOut:
		return
	
	# selections override direction, in case of slight drift
	var selection = UIController.get_selection()
	var direction = UIController.get_direction()
	if selection == UIController.SELECTION.ACCEPT && focusedElement != null:
		# select and unfocus
		focusedElement.select()
		focusedElement.focus(false)
	elif direction != Vector2.ZERO && cooldown.is_stopped():
		refocus(direction)


func get_focused_index() -> int:
	return focusedRow.focusedIndex


func set_focused_index(index: int) -> void:
	focusedRow.focusedIndex = index


func handle_button_focused(button: Button3D) -> void:
	# ensure this system is what we want
	if !isActive:
		return
	
	# lets not refocus on the same thing
	if focusedElement == button:
		return
	
	# swap focus
	focusedElement.focus(false)
	focusedElement = button


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
	
	# ensure there is a returned element
	if focusedElement == null:
		rowIndex = -1
		focusedRow = buttonRow
		focusedElement = focusedRow.elements[0]
	
	# finally, focus on element
	focusedElement.focus()
	
	# notify container of focused item
	if focusedElement is ShopSlot:
		emit_signal("item_focused", focusedElement.item.data)
	
	# ensure focus doesn't move too fast
	cooldown.start(COOLDOWN)


func row_down() -> void:
	# loop until we find an enabled row
	while(true):
		# ensure index does not exceed bounds
		rowIndex += 1
		if rowIndex == itemRows.size():
			rowIndex = -1
			var index: int = floori(focusedRow.focusedIndex / 2)
			focusedRow = buttonRow
			focusedElement = buttonRow.elements[index]
			return
		
		# check availability
		if swap_row_focus():
			return


func row_up() -> void:
		# loop until we find an enabled row
	while(true):
		# ensure index does not exceed bounds
		rowIndex -= 1
		if rowIndex == -1:
			# set focus to the buttons
			var index: int = floori(focusedRow.focusedIndex / 2)
			focusedRow = buttonRow
			focusedElement = buttonRow.elements[index]
			return
		elif rowIndex < -1:
			rowIndex = itemRows.size() - 1
		
		# check availability
		if swap_row_focus():
			return


func swap_row_focus() -> bool:
	# set new index
	var elementIndex = focusedRow.focusedIndex
	
	# if on the button row, even out the next index
	if focusedRow is FocusRow:
		elementIndex *= 2
	
	# if disabled, return false
	if itemRows[rowIndex].element_enabled(elementIndex):
		focusedRow = itemRows[rowIndex]
		focusedElement = focusedRow.set_focus(elementIndex)
		return true
	else:
		return false


func handle_mouse_focused(slot: ShopSlot) -> void:
	# ensure this system is what we want
	if !isActive:
		return
	
	# swap focus
	focusedElement.focus(false)
	focusedElement = slot
	focusedElement.focus(true)
	
	# set new focus
	var elementIndex = itemRows[0].find(focusedElement)
	if elementIndex < 0:
		rowIndex = 1
	else:
		rowIndex = 0
	focusedRow = itemRows[rowIndex]
	
	# notify container of focused item
	emit_signal("item_focused", slot.item.data)


func handle_attempt_purchase(cost: float) -> void:
	# first, make sure we aren't buying two items at once
	if !cooldown.is_stopped() || !isActive:
		return
	
	# validate Moni before purchase
	if cost < TrashData.moni:
		# ensure no other items are purchased during this cycle
		# charge user
		TrashData.moni -= cost
		
		# notify container of focused item
		if focusedElement is ShopSlot:
			var index = (focusedRow as ShopRow).find(focusedElement as ShopSlot)
			emit_signal("item_purchased", index + rowIndex * SLOTS_PER_ROW)
		
		# shift to a new focus
		refocus(Vector2(1,0))
		
		# start cooldown timer
		cooldown.start(COOLDOWN)
