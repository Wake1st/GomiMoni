class_name SettingsFocusSystem
extends Node


signal cancel_selected

@export var rows: Array[Slider3D]
@export var cancelButton: CancelOption

var isActive: bool = false
var rowIndex: int = 0
var focusedElement: Slider3D
var cancelFocused: bool = false


func activate(value: bool = true) -> void:
	isActive = value


func _input(_event) -> void:
	# ensure this system is what we want
	if !isActive:
		return
	
	# selections override direction, in case of slight drift
	var selection = UIController.get_selection()
	var direction = UIController.get_direction()
	if selection == UIController.SELECTION.ACCEPT && focusedElement != null:
		if cancelFocused:
			cancelButton.select()
	elif selection == UIController.SELECTION.CANCEL:
		emit_signal("cancel_selected")
	elif direction != Vector2.ZERO:
		refocus(direction)


func refocus(direction: Vector2) -> void:
	# first, unfocus current element
	if cancelFocused:
		cancelButton.focus(false)
	
	# swap rows
	if direction.y > 0:
		row_up()
	elif direction.y < 0:
		row_down()
	
	# move along rows
	if direction.x != 0:
		focusedElement.adjust(direction.x)
	
	# finally, focus on element
	if cancelFocused:
		cancelButton.focus()


func row_up() -> void:
	# ensure index does not exceed bounds
	rowIndex -= 1
	if rowIndex < -1:
		rowIndex = rows.size() - 1
		focusedElement = rows[rowIndex]
		cancelFocused = false
	elif rowIndex < 0:
		focusedElement = null
		cancelFocused = true
	else:
		focusedElement = rows[rowIndex]


func row_down() -> void:
	# ensure index does not exceed bounds
	rowIndex += 1
	if rowIndex == rows.size():
		rowIndex = -1
		focusedElement = null
		cancelFocused = true
	else:
		focusedElement = rows[rowIndex]
		cancelFocused = false
