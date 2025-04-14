class_name Instructions
extends Node3D


enum POPUP {
	MOVEMENT,
	SWAPPING
}

const POPUP_DURATION: float = 4.0

@onready var movement: PopUp3D = $Movement
@onready var swapping: PopUp3D = $Swapping

var isOpen: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		toggle_menu()


func toggle_menu() -> void:
		# only allow if in the level
	if StageState.currentState != StageState.STAGES.LEVEL:
		return
	
	if isOpen:
		# turn off the vehicle controls
		UIController.isActive = false
		
		# animate the pause menu
		movement.off()
		swapping.off()
	else:
		# turn off the vehicle controls
		VehicleController.isActive = false
		
		# animate the pause menu
		movement.on()
		swapping.on()
	
	# update state
	isOpen = !isOpen
	
	# ensure controls are working
	if isOpen:
		UIController.isActive = true
	else:
		VehicleController.isActive = true


func popup_instruction(popup: POPUP) -> void:
	match popup:
		POPUP.MOVEMENT:
			movement.on(POPUP_DURATION)
		POPUP.SWAPPING:
			swapping.on(POPUP_DURATION)
