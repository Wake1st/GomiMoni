class_name ShopCamera
extends Node3D


signal transition_finished(isOpen: bool)

const CLOSED_ROTATION_X: float = -PI/2
const OPENED_ROTATION_X: float = -PI/12
const ROTATION_DURATION: float = 1.2

@onready var camera = $Camera

var rotationTween: Tween


func _ready() -> void:
	camera.rotation.x = CLOSED_ROTATION_X


func open_transition() -> void:
	# first, ensure this is the live camera
	camera.current = true
	
	# tween where the camera looks
	rotationTween = create_tween()
	rotationTween.tween_property(camera, "rotation:x", OPENED_ROTATION_X, ROTATION_DURATION)
	rotationTween.tween_callback(handle_transition_ended.bind(true))


func close_transition() -> void:
	print("closing shop...")
	# tween where the camera looks
	rotationTween = create_tween()
	rotationTween.tween_property(camera, "rotation:x", CLOSED_ROTATION_X, ROTATION_DURATION)
	rotationTween.tween_callback(handle_transition_ended.bind(false))


func handle_transition_ended(isOpen: bool) -> void:
	emit_signal("transition_finished", isOpen)
