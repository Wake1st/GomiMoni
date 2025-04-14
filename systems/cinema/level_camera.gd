class_name LevelCamera
extends Node3D


signal transition_finished(isOpen: bool)

const CAMERA_CENTER_OFFSET: float = 0.2
const CAMERA_LOOK: Vector3 = Vector3(0,0,CAMERA_CENTER_OFFSET)
const CLOSED_SIZE: float = 0.6
const OPENED_POSITION_Z: float = 12.0
const CLOSED_POSITION_Z: float = CAMERA_CENTER_OFFSET
const SLIDE_DURATION: float = 0.8
const ZOOM_DURATION: float = 1.2

@export var opened_size: float = 16

@onready var camera: Camera3D = $Camera

var zoomTween: Tween
var slideTween: Tween
var isSliding: bool = false


func _ready() -> void:
	camera.size = CLOSED_SIZE
	camera.position.z = CLOSED_POSITION_Z


func _process(_delta):
	if isSliding:
		camera.look_at(CAMERA_LOOK, Vector3.FORWARD)


func open_transition() -> void:
	# first, ensure this is the live camera
	camera.current = true
	
	# zoom out of the goal 
	zoomTween = create_tween()
	zoomTween.tween_property(camera, "size", opened_size, ZOOM_DURATION)
	
	# move camera away from the goal
	slideTween = create_tween()
	slideTween.tween_interval(ZOOM_DURATION - SLIDE_DURATION)
	slideTween.tween_callback(func(): isSliding = true)
	slideTween.tween_property(camera, "position:z", OPENED_POSITION_Z, SLIDE_DURATION)
	slideTween.tween_callback(handle_transition_ended.bind(true))


func close_transition() -> void:
	# we need to look at the goal while we slide
	isSliding = true
	
	# move camera over the goal
	slideTween = create_tween()
	slideTween.tween_property(camera, "position:z", CLOSED_POSITION_Z, SLIDE_DURATION)
	slideTween.tween_callback(func(): isSliding = false)
	
	# zoom in on the goal
	zoomTween = create_tween()
	zoomTween.tween_property(camera, "size", CLOSED_SIZE, ZOOM_DURATION)
	zoomTween.tween_callback(handle_transition_ended.bind(false))


func handle_transition_ended(isOpen) -> void:
	emit_signal("transition_finished", isOpen)
