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


func toggle_menu(value: bool) -> void:
		# only allow if in the level
	if StageState.currentState != StageState.STAGES.LEVEL:
		return
	
	# update state
	isOpen = value
	
	if isOpen:
		# animate the pause menu
		movement.on()
		swapping.on()
	else:
		# animate the pause menu
		movement.off()
		swapping.off()


func popup_instruction(popup: POPUP) -> void:
	match popup:
		POPUP.MOVEMENT:
			movement.on(POPUP_DURATION)
		POPUP.SWAPPING:
			swapping.on(POPUP_DURATION)
