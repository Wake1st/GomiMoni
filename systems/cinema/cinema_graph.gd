class_name CinemaGraph
extends Node


enum STILLS {
	ROOT,
	CREDITS,
	SETTINGS,
	SELECTION
}

@export var transitionDuration = 1.4
@export var lookDuration = 0.4

@export var rootShot: Camera3D
@export var creditShot: Camera3D
@export var settingsShot: Camera3D
@export var selectionShot: Camera3D

@export var rootCreditPath: Path3D
@export var rootSettingsPath: Path3D
@export var rootSelectionPath: Path3D

@onready var camera_base: PathFollow3D = $RootCreditPath/CameraBase
@onready var live_camera: Camera3D = $RootCreditPath/CameraBase/LiveCamera

var currentShot: CinemaGraph.STILLS
var tweenFollower: Tween
var tweenSize: Tween
var tweenBasis: Tween


#region SETUP
func _ready():
	align_positions()
	align_directions()
	
	# turn off shot cameras
	rootShot.visible = false
	creditShot.visible = false
	settingsShot.visible = false
	selectionShot.visible = false
	
	# match the live camera to the root camera
	live_camera.position = rootShot.position
	live_camera.size = rootShot.size
	live_camera.global_basis = rootShot.global_basis

## connect the end path nodes to the camera transforms
func align_positions() -> void:
	var rootPosition = rootShot.position
	rootCreditPath.curve.set_point_position(0, rootPosition)
	rootSettingsPath.curve.set_point_position(0, rootPosition)
	rootSelectionPath.curve.set_point_position(0, rootPosition)
	
	rootCreditPath.curve.set_point_position(
		rootCreditPath.curve.point_count-1, 
		creditShot.position
	)
	rootSettingsPath.curve.set_point_position(
		rootSettingsPath.curve.point_count-1, 
		settingsShot.position
	)
	rootSelectionPath.curve.set_point_position(
		rootSelectionPath.curve.point_count-1, 
		selectionShot.position
	)

func align_directions() -> void:
	var rootDirection = -rootShot.global_basis.z
	rootCreditPath.curve.set_point_out(0, rootDirection)
	rootSettingsPath.curve.set_point_out(0, rootDirection)
	rootSelectionPath.curve.set_point_out(0, rootDirection)
	
	rootCreditPath.curve.set_point_in(
		rootCreditPath.curve.point_count-1, 
		creditShot.global_basis.z
	)
	rootSettingsPath.curve.set_point_in(
		rootSettingsPath.curve.point_count-1, 
		settingsShot.global_basis.z
	)
	rootSelectionPath.curve.set_point_in(
		rootSelectionPath.curve.point_count-1, 
		selectionShot.global_basis.z
	)

#endregion


func traverse(endShot: Camera3D, forward: bool, parent: Path3D = null) -> void:
	if parent == null:
		parent = camera_base.get_parent()
	
	if forward and parent != camera_base.get_parent():
		camera_base.get_parent().remove_child(camera_base)
		parent.add_child(camera_base)
	
	var endRatio = 1.0 if forward else 0.0
	tweenFollower = create_tween()
	tweenFollower.tween_property(camera_base, "progress_ratio", endRatio, transitionDuration)
	
	var currentLook = live_camera.global_position - live_camera.global_basis.z
	var finalLook = endShot.global_position - endShot.basis.z
	tweenSize = create_tween()
	tweenSize.tween_method(live_camera.look_at, currentLook, finalLook, lookDuration)
	
	tweenBasis = create_tween()
	tweenBasis.tween_property(live_camera, "global_basis", endShot.global_basis, transitionDuration)
