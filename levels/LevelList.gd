class_name LevelList


static var highestLevel: int = -1
static var currentLevel: int = -1

static var items: Dictionary = {
	0: preload("res://levels/basics/gomi_to_hole.tscn"),
	1: preload('res://levels/basics/s_bend.tscn'),
	2: preload("res://levels/heavy/heavy_to_basket.tscn"),
	3: preload("res://levels/heavy/two_baskets.tscn"),
	4: preload("res://levels/flyer/flyer_to_switch.tscn"),
	5: preload("res://levels/flyer/which_switch.tscn"),
}


static func increment_level() -> void:
	# first, check highest
	if currentLevel - 1 == highestLevel && highestLevel + 1 < items.size():
		highestLevel += 1
	
	# then, update current
	if currentLevel < items.size():
		currentLevel += 1


## Return the level asked for; defaults to the highest level
static func get_level(number: int) -> PackedScene:
	currentLevel = number
	return items[number]


static func size() -> int:
	return items.size()


static func current_level_index() -> int:
	return currentLevel


static func highest_allowed_index() -> int:
	return highestLevel + 1


static func past_final_level() -> bool:
	return currentLevel == items.size()


static func all_levels_complete() -> bool:
	return items.size() - 1 == highestLevel
