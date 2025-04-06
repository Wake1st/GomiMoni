class_name ShopSlot
extends Node3D


@export var liftDistance: float = 0.8
@export var liftDuration: float = 0.2

var item: Trash
var tween: Tween


func add_trash(trash: Trash) -> void:
	item = trash
	add_child(trash)
	trash.global_position = global_position


func remove_trash() -> Trash:
	remove_child(item)
	var trash:Trash = item
	item = null
	return trash


func get_trash_position() -> Vector3:
	return item.global_position


func is_empty() -> bool:
	return item == null


func focus() -> void:
	tween = create_tween()
	tween.tween_property(item, "position:y", liftDistance, liftDuration)


func unfocus() -> void:
	tween = create_tween()
	tween.tween_property(item, "position:y", 0.0, liftDuration)
