class_name SelectorCamera
extends Node3D


signal transition_finished(isOpen: bool)

const CLOSE_ROTATION: Vector3 = Vector3(-PI/2, 0, 0)
const DURATION: float = 1.2

@onready var camera = $Camera

var openRotation: Vector3
var rotationTween: Tween


func setup(node: Node3D) -> void:
	camera.global_rotation = node.global_rotation
	camera.global_position = node.global_position
	
	openRotation = node.global_rotation


func open_transition() -> void:
	# first, ensure this is the live camera
	camera.current = true
	
	# tween where the camera looks
	rotationTween = create_tween()
	rotationTween.tween_property(camera, "rotation:x", openRotation.x, DURATION)
	rotationTween.parallel()
	rotationTween.tween_property(camera, "rotation:y", openRotation.y, DURATION)
	rotationTween.tween_callback(handle_transition_ended.bind(true))


func close_transition() -> void:
	# tween where the camera looks
	rotationTween = create_tween()
	rotationTween.tween_property(camera, "rotation:x", CLOSE_ROTATION.x, DURATION)
	rotationTween.parallel()
	rotationTween.tween_property(camera, "rotation:y", CLOSE_ROTATION.y, DURATION)
	rotationTween.tween_callback(handle_transition_ended.bind(false))


func handle_transition_ended(isOpen: bool) -> void:
	emit_signal("transition_finished", isOpen)
