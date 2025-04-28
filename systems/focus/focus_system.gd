class_name FocusSystem
extends Node


signal cancel_selected

const COOLDOWN_TIME: float = 0.1

@export var rows: Array[FocusRow]
@onready var cooldown:Timer = $Cooldown

var isActive: bool = false
var rowIndex: int = 0
var focusedRow: FocusRow
var focusedElement: Button3D


func activate(value: bool = true) -> void:
	isActive = value
	
	# set initial focus
	focusedRow = rows[rowIndex]
	focusedElement = focusedRow.set_focus(0)
	focusedElement.focus()


func _input(_event) -> void:
	# ensure this system is what we want
	if !isActive:
		return
	
	# selections override direction, in case of slight drift
	var selection = UIController.get_selection()
	var direction = UIController.get_direction()
	if selection == UIController.SELECTION.ACCEPT && focusedElement != null:
		# select nd unfocus
		focusedElement.select()
		focusedElement.focus(false)
	elif selection == UIController.SELECTION.CANCEL:
		emit_signal("cancel_selected")
	elif direction != Vector2.ZERO && cooldown.is_stopped():
		refocus(direction)
		
		# ensure focus doesn't move too fast
		cooldown.start(COOLDOWN_TIME)


func focus_on(element: Button3D) -> void:
		# ensure this system is what we want
	if !isActive:
		return
	
	# unfocus the current element
	focusedElement.focus(false)
	
	# find the row and set indecies
	for row in rows:
		var index = row.find(element)
		if index >= 0:
			focusedRow = row
			rowIndex = rows.find(row)
	
	# set the new focus
	focusedElement = element


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


func row_up() -> void:
	# loop until we find an enabled row
	while(true):
		# ensure index does not exceed bounds
		rowIndex -= 1
		if rowIndex < 0:
			rowIndex = rows.size() - 1
		
		# check availability
		if swap_row_focus():
			return


func row_down() -> void:
	# loop until we find an enabled row
	while(true):
		# ensure index does not exceed bounds
		rowIndex += 1
		if rowIndex == rows.size():
			rowIndex = 0
		
		# check availability
		if swap_row_focus():
			return


func swap_row_focus() -> bool:
	# set new index
	var elementIndex = focusedRow.focusedIndex
	
	# if disabled, return false
	if rows[rowIndex].element_enabled(elementIndex):
		focusedRow = rows[rowIndex]
		focusedElement = focusedRow.set_focus(elementIndex)
		return true
	else:
		return false
