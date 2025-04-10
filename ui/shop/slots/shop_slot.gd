class_name ShopSlot
extends Node3D


signal mouse_focused(slot: ShopSlot)
signal attempt_purchase(cost: float)

@export var trashScene: PackedScene
@export var liftDistance: float = 0.2
@export var liftDuration: float = 0.2

var item: TrashItem
var tween: Tween

var isPurchased: bool = false
var isFocused: bool = false


func _ready():
	item = trashScene.instantiate()
	add_child(item)


func remove_item() -> TrashItem:
	isPurchased = true
	isFocused = false
	
	remove_child(item)
	var trashItem:TrashItem = item
	item = null
	return trashItem


func get_trash_position() -> Vector3:
	return item.global_position


func is_empty() -> bool:
	return item == null


func focus() -> void:
	isFocused = true
	
	tween = create_tween()
	tween.tween_property(item, "position:y", liftDistance, liftDuration)


func unfocus() -> void:
	isFocused = false
	
	tween = create_tween()
	tween.tween_property(item, "position:y", 0.0, liftDuration)


func _input(event) -> void:
	if event.is_action_pressed("ui_accept") && isFocused && UIController.isActive:
		emit_signal("attempt_purchase", item.data.cost)


func _on_mouse_collider_mouse_entered():
	if !isPurchased:
		focus()
		emit_signal("mouse_focused", self)
