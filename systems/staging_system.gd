class_name StagingSystem
extends Node3D


signal transition_finished(oldLevel: Node3D)

const CAMERA_SIZE: float = 22.
const CAMERA_FLIP: float = 3.2
const CAMERA_SHIFT: float = 0.6

@export var shrinkTime: float = 1.6
@export var flipTime: float = 0.4
@export var shiftTime: float = 0.2
@export var growTime: float = 1.8

@onready var currentHolder: Node3D = $CurrentHolder
@onready var nextHolder: Node3D = $NextHolder
@onready var camera: Camera3D = $Camera

var currentHolderStart: Vector3 = Vector3.ZERO
var stageTween: Tween


func setup(current: Node3D) -> void:
	currentHolder.add_child(current)
	current.global_position = currentHolder.global_position


func transition(nextLevel: Node3D) -> void:
	nextHolder.add_child(nextLevel)
	nextLevel.global_position = nextHolder.global_position
	run_stages()


func _ready():
	# ensure camera looks at origin
	camera.size = CAMERA_SIZE
	camera.look_at(Vector3.ZERO)
	
	nextHolder.position = -camera.position


func run_stages() -> void:
	stageTween = create_tween()
	stageTween.tween_property(camera, "size", CAMERA_FLIP, shrinkTime)
	stageTween.tween_property(camera, "size", CAMERA_SHIFT, shrinkTime)
	stageTween.set_parallel()
	stageTween.tween_property(currentHolder, "rotation:x", PI/2 + camera.rotation.x, flipTime)
	stageTween.set_parallel(false)
	stageTween.tween_property(currentHolder, "position", camera.position * 1.4, shiftTime)
	stageTween.tween_property(camera, "size", CAMERA_SIZE, growTime)
	stageTween.tween_callback(swap_levels)


func swap_levels() -> void:
	# empty and reset current holder
	var oldLevel = currentHolder.get_child(0)
	currentHolder.remove_child(oldLevel)
	currentHolder.position = currentHolderStart
	currentHolder.global_rotation = Vector3.ZERO
	
	# swap active level
	var activeLevel = nextHolder.get_child(0)
	nextHolder.remove_child(activeLevel)
	currentHolder.add_child(activeLevel)
	activeLevel.global_position = currentHolder.global_position
	
	# pass back old level
	emit_signal("transition_finished", oldLevel)
