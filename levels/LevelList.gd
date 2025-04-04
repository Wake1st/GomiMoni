class_name LevelList


static var highestLevel: int = 0
static var items: Dictionary = {
	0: preload("res://levels/basics/gomi_to_hole.tscn"),
	1: preload('res://levels/basics/slopes.tscn'),
	2: preload("res://levels/heavy/heavy_to_basket.tscn"),
	3: preload("res://levels/heavy/two_baskets.tscn"),
	4: preload("res://levels/flyer/flyer_to_switch.tscn"),
	5: preload("res://levels/flyer/which_switch.tscn"),
}


static func increment_level() -> void:
	if highestLevel + 1 < items.size():
		highestLevel += 1


## Return the level asked for; defaults to the highest level
static func get_level(number: int = -1) -> PackedScene:
	if number < 0:
		number = highestLevel
	
	return items[number]


static func size() -> int:
	return items.size()
