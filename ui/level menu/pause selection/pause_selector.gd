class_name PauseSelector
extends Node3D


const CLOSED_POSITION_Z: float = 26
const OPENED_POSITION_Z: float = 7.8
const TWEEN_DURATION: float = 0.2

var isOpen: bool = false
var tween: Tween


func _ready() -> void:
	position.z = CLOSED_POSITION_Z


func setup(focusedCallable: Callable, selectedCallable: Callable) -> void:
	for child: PauseOption in get_children():
		child.setup()
		child.focused.connect(focusedCallable)
		child.selected.connect(selectedCallable)


func toggle_menu(value: bool) -> void:
	# only allow if in the level
	if StageState.currentState != StageState.STAGES.LEVEL:
		return
	
	isOpen = value
	tween = create_tween()
	if isOpen:
		# turn off the vehicle controls
		VehicleController.isActive = false
		
		# animate the pause menu
		tween.tween_property(self, "position:z", OPENED_POSITION_Z, TWEEN_DURATION)
		tween.tween_callback(handle_transition_ended)
	else:
		# turn off the UI controls
		UIController.isActive = false
		
		# animate the pause menu
		tween.tween_property(self, "position:z", CLOSED_POSITION_Z, TWEEN_DURATION)
		tween.tween_callback(handle_transition_ended)


func handle_transition_ended() -> void:
	# ensure controls are working
	if isOpen:
		UIController.isActive = true
	else:
		VehicleController.isActive = true
