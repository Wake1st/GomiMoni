class_name PauseSelector
extends Node3D


const CLOSED_POSITION_Z: float = 26
const OPENED_POSITION_Z: float = 7.8
const TWEEN_DURATION: float = 0.2

var isOpen: bool = false
var tween: Tween


func _ready() -> void:
	position.z = CLOSED_POSITION_Z


func setup(callback: Callable) -> void:
	for child: PauseOption in get_children():
		child.setup()
		child.selected.connect(callback)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		toggle_menu()


func toggle_menu() -> void:
	# only allow if in the level
	if StageState.currentState != StageState.STAGES.LEVEL:
		return
	
	tween = create_tween()
	if isOpen:
		# turn off the vehicle controls
		UIController.isActive = false
		
		# animate the pause menu
		tween.tween_property(self, "position:z", CLOSED_POSITION_Z, TWEEN_DURATION)
		tween.tween_callback(handle_transition_ended.bind(false))
	else:
		# turn off the vehicle controls
		VehicleController.isActive = false
		
		# animate the pause menu
		tween.tween_property(self, "position:z", OPENED_POSITION_Z, TWEEN_DURATION)
		tween.tween_callback(handle_transition_ended.bind(true))


func handle_transition_ended(toOpen) -> void:
	# update state
	isOpen = toOpen
	
	# ensure controls are working
	if toOpen:
		UIController.isActive = true
	else:
		VehicleController.isActive = true
