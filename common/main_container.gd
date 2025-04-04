class_name MainContainer
extends Node3D


signal main_closed
signal level_selection(number: int)

@onready var levelSelector: LevelSelector = $LevelSelector
@onready var selectorCamera: SelectorCamera = $SelectorCamera
@onready var selectionCamera: Camera3D = %SelectionCamera


func _ready():
	levelSelector.setup(handle_level_selected)
	selectorCamera.setup(selectionCamera)


func handle_level_selected(number: int) -> void:
	# animate camera through tube
	selectorCamera.close_transition()
	
	# notify staging system for level loading
	emit_signal("level_selection", number)


func handle_transition_ended(_isOpen: bool) -> void:
	if !_isOpen:
		emit_signal("main_closed")
