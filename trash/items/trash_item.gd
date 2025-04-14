class_name TrashItem
extends Node3D


const BOUGHT_ROTATION_Y: float = -PI/2
const ROTATION_DURATION: float = 0.5

@export var data: Trash

@onready var model = $Model

var tween: Tween


func rotate_to_bought() -> void:
	tween = create_tween()
	tween.tween_property(model, "global_rotation:y", BOUGHT_ROTATION_Y, ROTATION_DURATION)
	tween.set_ease(Tween.EASE_OUT)
