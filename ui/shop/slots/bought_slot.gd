class_name BoughtSlot
extends Node3D


const PURCHASE_DURATION: float = 0.6

var item: TrashItem
var purchaseTween: Tween


func store_item(trash:TrashItem, initialPosition: Vector3) -> void:
	item = trash
	
	# ensure position doesn't shift
	add_child(trash)
	trash.global_position = global_position + initialPosition
	
	# slowly move trash to bought slot
	purchaseTween = create_tween()
	purchaseTween.tween_property(trash, "global_position", global_position, PURCHASE_DURATION)
	purchaseTween.set_ease(Tween.EASE_IN_OUT)
	
	# rotate the item model
	trash.rotate_to_bought()
