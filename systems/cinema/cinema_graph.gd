class_name CinemaGraph
extends Node3D


enum STILLS {
	ROOT,
	CREDITS,
	SETTINGS,
	SELECTION
}

const CURVE_MAGNITUDE: float = 2.9

@export var transitionDuration = 1.4
@export var lookDuration = 0.4

@export var rootShot: Camera3D
@export var creditShot: Camera3D
@export var settingsShot: Camera3D
@export var selectionShot: Camera3D

@export var rootCreditPath: Path3D
@export var rootSettingsPath: Path3D
@export var rootSelectionPath: Path3D

@export var cameraBase: PathFollow3D
@export var liveCamera: LiveCamera

var currentShot: CinemaGraph.STILLS
var tween: Tween


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
	liveCamera.global_position = rootShot.global_position
	liveCamera.fov = rootShot.fov
	liveCamera.global_basis = rootShot.global_basis


## connect the end path nodes to the camera transforms
func align_positions() -> void:
	var rootPosition = rootShot.global_position
	rootCreditPath.curve.set_point_position(0, rootPosition)
	rootSettingsPath.curve.set_point_position(0, rootPosition)
	rootSelectionPath.curve.set_point_position(0, rootPosition)
	
	rootCreditPath.curve.set_point_position(
		rootCreditPath.curve.point_count-1, 
		creditShot.global_position
	)
	rootSettingsPath.curve.set_point_position(
		rootSettingsPath.curve.point_count-1, 
		settingsShot.global_position
	)
	rootSelectionPath.curve.set_point_position(
		rootSelectionPath.curve.point_count-1, 
		selectionShot.global_position
	)


func align_directions() -> void:
	var rootDirection = -rootShot.global_basis.z * CURVE_MAGNITUDE
	rootCreditPath.curve.set_point_out(0, rootDirection)
	rootSettingsPath.curve.set_point_out(0, rootDirection)
	rootSelectionPath.curve.set_point_out(0, rootDirection)
	
	rootCreditPath.curve.set_point_in(
		rootCreditPath.curve.point_count-1, 
		creditShot.global_basis.z * CURVE_MAGNITUDE
	)
	rootSettingsPath.curve.set_point_in(
		rootSettingsPath.curve.point_count-1, 
		settingsShot.global_basis.z * CURVE_MAGNITUDE
	)
	rootSelectionPath.curve.set_point_in(
		rootSelectionPath.curve.point_count-1, 
		selectionShot.global_basis.z * CURVE_MAGNITUDE
	)

#endregion


func send_camera(shot: STILLS) -> void:
	match shot:
		STILLS.ROOT:
			traverse(rootShot, false)
		STILLS.SELECTION:
			traverse(selectionShot, true, rootSelectionPath)
		STILLS.SETTINGS:
			traverse(settingsShot, true, rootSettingsPath)
		STILLS.CREDITS:
			traverse(creditShot, true, rootCreditPath)


func traverse(endShot: Camera3D, forward: bool, parent: Path3D = null) -> void:
	if parent == null:
		parent = cameraBase.get_parent()
	
	if forward and parent != cameraBase.get_parent():
		cameraBase.get_parent().remove_child(cameraBase)
		parent.add_child(cameraBase)
	
	# setup tween
	tween = create_tween()
	tween.set_parallel(true)
	
	# move camera sled / base
	var endRatio = 1.0 if forward else 0.0
	tween.tween_property(cameraBase, "progress_ratio", endRatio, transitionDuration)
	
	# look at target
	var currentLook = liveCamera.global_position - liveCamera.global_basis.z
	var finalLook = endShot.global_position - endShot.basis.z
	tween.tween_method(liveCamera.look_at, currentLook, finalLook, lookDuration)
	
	# ensure the final basis is correct
	tween.tween_property(liveCamera, "global_basis", endShot.global_basis, transitionDuration)
	
	# reset to series
	tween.set_parallel(false)
