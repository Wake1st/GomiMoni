class_name StagingSystem
extends Node3D


signal shop_opened
signal level_opened

const CAMERA_SIZE: float = 22.
const CAMERA_FLIP: float = 3.2
const CAMERA_SHIFT: float = 0.6

@export var shrinkTime: float = 1.6
@export var flipTime: float = 0.4
@export var shiftTime: float = 0.2
@export var growTime: float = 1.8

@onready var levelHolder: Node3D = $CurrentHolder
@onready var shopHolder: Node3D = $NextHolder
@onready var camera: Camera3D = $Camera

var waitingPosition: Vector3
var nextLevel: LevelContainer
var stageTween: Tween


func setup(current: Node3D) -> void:
	levelHolder.add_child(current)
	current.global_position = levelHolder.global_position


func transition(next: LevelContainer) -> void:
	nextLevel = next
	run_stages()


func _ready():
	# ensure camera looks at origin
	camera.size = CAMERA_SIZE
	camera.look_at(Vector3.ZERO)
	
	waitingPosition = -camera.position
	shopHolder.position = waitingPosition


func run_stages() -> void:
	stageTween = create_tween()
	stageTween.tween_property(camera, "size", CAMERA_FLIP, shrinkTime)
	stageTween.tween_property(camera, "size", CAMERA_SHIFT, shrinkTime)
	stageTween.set_parallel()
	stageTween.tween_property(levelHolder, "rotation:x", PI/2 + camera.rotation.x, flipTime)
	stageTween.set_parallel(false)
	stageTween.tween_property(levelHolder, "position", camera.position * 1.4, shiftTime)
	stageTween.tween_property(camera, "size", CAMERA_SIZE, growTime)
	stageTween.tween_callback(open_shop)


func open_shop() -> void:
	# empty and reset current holder
	var oldLevel = levelHolder.get_child(0)
	levelHolder.remove_child(oldLevel)
	levelHolder.position = waitingPosition
	levelHolder.global_rotation = Vector3.ZERO
	
	# pass back old level
	emit_signal("shop_opened")


func open_level() -> void:
	# swap active level
	levelHolder.add_child(nextLevel)
	shopHolder.global_position = waitingPosition
	
	# pass back old level
	emit_signal("level_opened")
