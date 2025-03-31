class_name LevelCamera
extends Node3D


signal transition_finished(isOpen: bool)

const CAMERA_LOOK: Vector3 = Vector3(0,0,-0.1)
const OPENED_SIZE: float = 22.
const CLOSED_SIZE: float = 0.6
const OPENED_POSITION_Z: float = 20.0
const CLOSED_POSITION_Z: float = 0.0
const SLIDE_DURATION: float = 1.2
const ZOOM_DURATION: float = 0.8

@onready var camera = $Camera

var levelTween: Tween
var isSliding: bool = false


func _ready() -> void:
	camera.current = true
	camera.size = OPENED_SIZE
	camera.position.z = OPENED_POSITION_Z


func _process(_delta):
	if isSliding:
		camera.look_at(CAMERA_LOOK)


func open_transition() -> void:
	# first, ensure this is the live camera
	camera.current = true
	
	# zoom out of the goal 
	levelTween = create_tween()
	levelTween.tween_property(camera, "size", OPENED_SIZE, ZOOM_DURATION)
	levelTween.tween_callback(func(): isSliding = true)
	
	# move camera away from the goal
	levelTween.tween_property(camera, "position:z", OPENED_POSITION_Z, SLIDE_DURATION)
	levelTween.tween_callback(handle_transition_ended.bind(true))


func close_transition() -> void:
	print("closing level...")
	# we need to look at the goal while we slide
	isSliding = true
	
	# move camera over the goal
	levelTween = create_tween()
	levelTween.tween_property(camera, "position:z", CLOSED_POSITION_Z, SLIDE_DURATION)
	levelTween.tween_callback(func(): isSliding = false)
	
	# zoom in on the goal 
	levelTween.tween_property(camera, "size", CLOSED_SIZE, ZOOM_DURATION)
	levelTween.tween_callback(handle_transition_ended.bind(false))


func handle_transition_ended(isOpen) -> void:
	emit_signal("transition_finished", isOpen)
