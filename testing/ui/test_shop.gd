extends Node3D


@onready var shop = $Shop

var focusedTrash: Trash


func _ready() -> void:
	TrashData.moni = 100
	
	shop.item_focused.connect(handle_item_focused)
	shop.item_purchased.connect(handle_item_purchased)


func handle_item_focused(item: Trash) -> void:
	print("focusing on: %s" % item.name)
	focusedTrash = item


func handle_item_purchased() -> void:
	print("buying: %s" % focusedTrash.name)
