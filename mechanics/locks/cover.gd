class_name Cover
extends Lock


const OPEN_ROTATION: float = -PI/2

@export var pivot_duration: float = 0.4

@onready var pivot = $pivot

var tween: Tween
var isOpened: bool = false


func lock() -> void:
	isOpened = false
	tween = null
	pivot.rotation.x = 0


func unlock() -> void:
	isOpened = true
	tween = create_tween()
	tween.tween_property(pivot, "rotation:x", OPEN_ROTATION, pivot_duration)
