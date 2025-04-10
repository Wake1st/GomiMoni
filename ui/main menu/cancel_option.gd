class_name CancelOption
extends StaticBody3D


signal selected

const HOVER_SHIFT: float = 0.2
const ANIMATION_DURATION: float = 0.1

var hasFocus: bool = false
var basePosition: Vector3
var hoverPosition: Vector3
var tween: Tween


func _ready() -> void:
	# set animation values
	basePosition = position
	hoverPosition = position + basis.z * HOVER_SHIFT


func setup(camera_position: Vector3) -> void:
	# ensures user can see the button
	look_at(camera_position)


func _input(event) -> void:
	if event.is_action_pressed("ui_accept") && hasFocus:
		emit_signal("selected")
		
		# animate selection
		tween = create_tween()
		tween.tween_property(self, "position", basePosition, ANIMATION_DURATION)
		tween.tween_property(self, "position", hoverPosition, ANIMATION_DURATION)


func _on_mouse_entered():
	hasFocus = true
	
	# animate toward camera
	tween = create_tween()
	tween.tween_property(self, "position", hoverPosition, ANIMATION_DURATION)
	tween.set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	hasFocus = false
	
	# animate away from camera
	tween = create_tween()
	tween.tween_property(self, "position", basePosition, ANIMATION_DURATION)
	tween.set_ease(Tween.EASE_OUT)
