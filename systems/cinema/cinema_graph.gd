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


func _ready():
	align_positions()
	align_directions()
	setup_cameras()


#region SETUP

## connect the end path nodes to the camera transforms
func align_positions() -> void:
	var rootPosition = rootShot.position
	rootCreditPath.curve.set_point_position(0, rootPosition)
	rootSettingsPath.curve.set_point_position(0, rootPosition)
	rootSelectionPath.curve.set_point_position(0, rootPosition)
	
	rootCreditPath.curve.set_point_position(1, creditShot.position)
	rootSettingsPath.curve.set_point_position(1, settingsShot.position)
	rootSelectionPath.curve.set_point_position(1, selectionShot.position)


func align_directions() -> void:
	var rootDirection = -rootShot.global_basis.z * CURVE_MAGNITUDE
	rootCreditPath.curve.set_point_out(0, rootDirection)
	rootSettingsPath.curve.set_point_out(0, rootDirection)
	rootSelectionPath.curve.set_point_out(0, rootDirection)
	
	rootCreditPath.curve.set_point_in(
		1,
		creditShot.global_basis.z * CURVE_MAGNITUDE
	)
	rootSettingsPath.curve.set_point_in(
		1,
		settingsShot.global_basis.z * CURVE_MAGNITUDE
	)
	rootSelectionPath.curve.set_point_in(
		1,
		selectionShot.global_basis.z * CURVE_MAGNITUDE
	)


func setup_cameras() -> void:
	# turn off shot cameras
	rootShot.visible = false
	creditShot.visible = false
	settingsShot.visible = false
	selectionShot.visible = false
	
	# match the live camera to the root camera
	liveCamera.position = rootShot.position
	liveCamera.fov = rootShot.fov
	liveCamera.global_basis = rootShot.global_basis

#endregion


func send_camera(shot: STILLS, instant: bool = false) -> void:
	match shot:
		STILLS.ROOT:
			traverse(rootShot, false, null, instant)
		STILLS.SELECTION:
			traverse(selectionShot, true, rootSelectionPath, instant)
		STILLS.SETTINGS:
			traverse(settingsShot, true, rootSettingsPath, instant)
		STILLS.CREDITS:
			traverse(creditShot, true, rootCreditPath, instant)


func traverse(endShot: Camera3D, forward: bool, parent: Path3D = null, instant: bool = false) -> void:
	if parent == null:
		parent = cameraBase.get_parent()
	
	if forward and parent != cameraBase.get_parent():
		# swap owners
		cameraBase.get_parent().remove_child(cameraBase)
		parent.add_child(cameraBase)
	
	# precalculate shared values
	var endRatio = 1.0 if forward else 0.0
	
	var currentLook = liveCamera.position + liveCamera.global_basis.z
	var finalLook = endShot.position + endShot.basis.z
	
	# set final values if instant
	if instant:
		cameraBase.progress_ratio = endRatio
		liveCamera.global_basis = endShot.global_basis
		liveCamera.look_at(finalLook)
	else:
		# setup tween
		tween = create_tween()
		tween.set_parallel(true)
		
		# move camera sled / base
		tween.tween_property(cameraBase, "progress_ratio", endRatio, transitionDuration)
		
		# ensure the final basis is correct
		tween.tween_property(liveCamera, "global_basis", endShot.global_basis, transitionDuration)
		
		# look at target
		tween.tween_method(liveCamera.look_at, currentLook, finalLook, lookDuration)
		
		# reset to series
		tween.set_parallel(false)
