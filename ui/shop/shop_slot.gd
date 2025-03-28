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


func focus() -> void:
	tween = create_tween()
	tween.tween_property(item, "position:y", liftDistance, liftDuration)


func unfocus() -> void:
	tween = create_tween()
	tween.tween_property(item, "position:y", 0.0, liftDuration)
