class_name ShopRow
extends Node


@export var elements: Array[ShopSlot]

var focusedIndex: int = 0


func set_focus(index: int) -> ShopSlot:
	# ensure the index does not exceed bounds
	focusedIndex = index
	if focusedIndex < 0:
		focusedIndex = elements.size() - 1
	elif focusedIndex >= elements.size():
		focusedIndex = 0
	
	return elements[focusedIndex]


func element_enabled(index: int) -> bool:
	# ensure our index does not exceed bounds
	if index < 0:
		index = elements.size() - 1
	elif index >= elements.size():
		index = 0
	
	# only enabled should be allowed
	return !elements[index].isPurchased


func get_next() -> ShopSlot:
	# do not pass disabled elements
	while (true):
		# loop index, if needed
		focusedIndex += 1
		if focusedIndex == elements.size():
			focusedIndex = 0
		
		# check availability
		if !elements[focusedIndex].isPurchased:
			return elements[focusedIndex]
	
	# if we can access a row, then we won't reach this point
	return null


func get_prev() -> ShopSlot:
		# do not pass disabled elements
	while (true):
		# loop index, if needed
		focusedIndex -= 1
		if focusedIndex < 0:
			focusedIndex = elements.size() - 1
		
		# check availability
		if !elements[focusedIndex].isPurchased:
			return elements[focusedIndex]
	
	# if we can access a row, then we won't reach this point
	return null
