class_name LiveCamera
extends Camera3D


signal transition_finished(isOpen: bool)

const CLOSE_ROTATION: Vector3 = Vector3(-PI/2, 0, 0)
const DURATION: float = 1.2

var startPosition: Vector3
var startRotation: Vector3
var openRotation: Vector3
var rotationTween: Tween


func setup(node: Node3D) -> void:
	# match the live camera with it's setup
	startPosition = node.global_position
	startRotation = node.global_rotation
	openRotation = rotation
	
	# ready the camera to be opened
	rotation.x = CLOSE_ROTATION.x


func open_transition() -> void:
	# first, ensure this is the live camera
	current = true
	
	# ready the camera to be opened
	global_position = startPosition
	global_rotation = startRotation
	rotation.x = CLOSE_ROTATION.x
	
	# tween where the camera looks
	rotationTween = create_tween()
	rotationTween.tween_property(self, "rotation:x", openRotation.x, DURATION)
	rotationTween.tween_callback(handle_transition_ended.bind(true))


func close_transition() -> void:
	# tween where the camera looks
	rotationTween = create_tween()
	rotationTween.tween_property(self, "rotation:x", CLOSE_ROTATION.x, DURATION)
	rotationTween.tween_callback(handle_transition_ended.bind(false))


func handle_transition_ended(isOpen: bool) -> void:
	emit_signal("transition_finished", isOpen)
