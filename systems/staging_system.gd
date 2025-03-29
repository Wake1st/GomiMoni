class_name StagingSystem
extends Node3D


signal shop_opened
signal level_opened

const CAMERA_SIZE: float = 22.
const CAMERA_FLIP: float = 3.2
const CAMERA_SHIFT: float = 0.6

const PRE_SHIFT_TIME: float = 1.0
const PRE_SHRINK_TIME: float = 0.8
const SHIFT_TIME: float = 0.2
const POST_SHRINK_TIME: float = 0.4
const POST_SHIFT_TIME: float = 0.6

@onready var levelContainer: LevelContainer = $LevelContainer
@onready var shopContainer: ShopContainer = $ShopContainer

@onready var camera: Camera3D = $Camera

var cameraLevelPosition: Vector3
var cameraOverHolePosition: Vector3
var cameraUnderHolePosition: Vector3
var cameraShopPosition: Vector3

var tween: Tween


func _ready():
	# ensure camera looks at origin
	camera.size = CAMERA_SIZE
	camera.look_at(Vector3.ZERO)
	
	# connect container signals
	levelContainer.level_finished.connect(handle_level_finished)
	shopContainer.shop_closed.connect(handle_shop_closed)
	levelContainer.main_selected.connect(handle_main_selected)
	shopContainer.main_selected.connect(handle_main_selected)


func setup(levelNumber: int = -1) -> void:
	levelContainer.open(levelNumber)


func handle_level_finished() -> void:
	transition_to_shop()


func handle_shop_closed() -> void:
	transition_to_level()


func handle_main_selected() -> void:
	print("main selected")


func transition_to_shop() -> void:
	tween = create_tween()
	# move camera over the hole
	#tween.tween_method(camera.look_at, 0.0, 0.0, CAMERA_TO_HOLE_TIME)
	#tween.tween_property(camera, "size", CAMERA_FLIP, SHRINK_TIME)
	#tween.tween_property(camera, "size", CAMERA_SHIFT, SHRINK_TIME)
	#tween.set_parallel()
	#tween.tween_property(levelContainer, "rotation:x", PI/2 + camera.rotation.x, FLIP_TIME)
	#tween.set_parallel(false)
	#tween.tween_property(levelContainer, "position", camera.position * 1.4, SHIFT_TIME)
	#tween.tween_property(camera, "size", CAMERA_SIZE, GROW_TIME)
	#tween.tween_callback(open_shop)


func transition_to_level() -> void:
	tween = create_tween()
	#tween.tween_property(camera, "")
	#tween.tween_callback(run_level)


func open_shop() -> void:
	# empty and reset current holder
	var oldLevel = levelContainer.get_child(0)
	levelContainer.remove_child(oldLevel)
	levelContainer.global_rotation = Vector3.ZERO
	
	# open the shop
	shopContainer.open()
	emit_signal("shop_opened")


func run_level() -> void:
	# run the next level
	levelContainer.run()
	emit_signal("level_opened")
