class_name StagingSystem
extends Node3D


signal shop_opened
signal level_opened

const CAMERA_LEVEL_SIZE: float = 22.
const CAMERA_SHIFT_SIZE: float = 0.6
const CAMERA_SHOP_FOV: float = 40

const PRE_SHIFT_TIME: float = 1.0
const PRE_SHRINK_TIME: float = 0.8
const SHIFT_TIME: float = 0.2
const POST_SHRINK_TIME: float = 0.4
const POST_SHIFT_TIME: float = 0.6

@onready var levelContainer: LevelContainer = $LevelContainer
@onready var shopContainer: ShopContainer = $ShopContainer

@onready var follower: PathFollow3D = %Follower
@onready var camera: Camera3D = %Camera

var cameraLevelPosition: Vector3
var cameraOverHolePosition: Vector3
var cameraUnderHolePosition: Vector3
var cameraShopPosition: Vector3

var lookTween: Tween
var sizeTween: Tween
var transitionTime: float = PRE_SHIFT_TIME + SHIFT_TIME + POST_SHIFT_TIME
var transitionTimer: float = 0.0
var cameraDelay: float = transitionTime - PRE_SHRINK_TIME - POST_SHRINK_TIME
var isGoingToShop: bool = false
var isLeavingShop: bool = false


func _ready() -> void:
	# ensure camera looks at origin
	camera.size = CAMERA_LEVEL_SIZE
	camera.look_at(Vector3.ZERO)
	
	# connect container signals
	levelContainer.level_finished.connect(handle_level_finished)
	shopContainer.shop_closed.connect(handle_shop_closed)
	levelContainer.main_selected.connect(handle_main_selected)
	shopContainer.main_selected.connect(handle_main_selected)


func _process(delta) -> void:
	if isGoingToShop:
		transitionTimer += delta
		if transitionTimer < transitionTime:
			var weight = lerp(0.0, transitionTime, transitionTimer)
			follower.progress_ratio = weight


func setup(levelNumber: int = -1) -> void:
	levelContainer.open(levelNumber)


func handle_level_finished() -> void:
	transition_to_shop()


func handle_shop_closed() -> void:
	transition_to_level()


func handle_main_selected() -> void:
	print("main selected")


func transition_to_shop() -> void:
	isGoingToShop = true
	
	# tween where the camera looks
	lookTween = create_tween()
	lookTween.tween_method(camera.look_at, Vector3.ZERO, Vector3.ZERO, PRE_SHIFT_TIME)
	lookTween.tween_method(camera.look_at, Vector3.ZERO, Vector3.DOWN * 15, SHIFT_TIME)
	lookTween.tween_method(camera.look_at, Vector3.DOWN * 15, Vector3(0,-15,-2), POST_SHIFT_TIME)
	
	# tween the camera projection
	sizeTween = create_tween()
	sizeTween.tween_property(camera, "size", CAMERA_SHIFT_SIZE, PRE_SHRINK_TIME)
	sizeTween.tween_interval(cameraDelay)
	sizeTween.tween_callback(camera_flip_perspective.bind(true))
	sizeTween.tween_property(camera, "fov", CAMERA_SHOP_FOV, POST_SHRINK_TIME)


func transition_to_level() -> void:
	isLeavingShop = true
	
	# tween where the camera looks
	lookTween = create_tween()
	lookTween.tween_method(camera.look_at, Vector3(0,-15,-2), Vector3.UP * 15, POST_SHIFT_TIME)
	lookTween.tween_method(camera.look_at, Vector3.UP * 15, Vector3.ZERO, SHIFT_TIME)
	lookTween.tween_method(camera.look_at, Vector3.ZERO, Vector3.ZERO, PRE_SHIFT_TIME)
	
	# tween the camera projection
	sizeTween = create_tween()
	sizeTween.tween_property(camera, "fov", 1, POST_SHRINK_TIME)
	sizeTween.tween_callback(camera_flip_perspective.bind(false))
	sizeTween.tween_interval(cameraDelay)
	sizeTween.tween_property(camera, "size", CAMERA_LEVEL_SIZE, PRE_SHRINK_TIME)


func camera_flip_perspective(toPerspective: bool) -> void:
	if toPerspective:
		camera.projection = Camera3D.PROJECTION_PERSPECTIVE
		camera.fov = 1.0
	else:
		camera.projection = Camera3D.PROJECTION_ORTHOGONAL
		camera.size = CAMERA_SHIFT_SIZE


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
