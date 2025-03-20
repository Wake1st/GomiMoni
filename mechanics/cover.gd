class_name Cover
extends Node3D


const OPEN_ROTATION: float = -PI/2

@export var pivot_duration: float = 0.4

@onready var pivot = $pivot

var tween: Tween
var isOpened: bool = false


func close() -> void:
	isOpened = false
	tween = null
	pivot.rotation.x = 0


func open() -> void:
	isOpened = true
	tween = create_tween()
	tween.tween_property(pivot, "rotation:x", OPEN_ROTATION, pivot_duration)
