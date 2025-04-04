class_name MainContainer
extends Node3D


signal main_closed
signal level_selection(number: int)

@onready var levelSelector: LevelSelector = $LevelSelector
@onready var selectorCamera: SelectorCamera = $SelectorCamera
@onready var selectionCamera: Camera3D = %SelectionCamera
@onready var mainSelector: MainSelector = $MainSelector
@onready var cinemaGraph = $CinemaGraph


func _ready():
	levelSelector.setup(handle_level_selected)
	mainSelector.setup(handle_main_selection)
	selectorCamera.setup(selectionCamera)


func run() -> void:
	# enable controls
	UIController.isActive = true


func handle_main_selection(option: MainOption.OPTIONS) -> void:
	match option:
		MainOption.OPTIONS.LEVELS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.SELECTION)
		MainOption.OPTIONS.SETTINGS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.SETTINGS)
		MainOption.OPTIONS.CREDITS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.CREDITS)


func handle_level_selected(number: int) -> void:
	# animate camera through tube
	selectorCamera.close_transition()
	
	# notify staging system for level loading
	emit_signal("level_selection", number)


func handle_transition_ended(_isOpen: bool) -> void:
	if !_isOpen:
		emit_signal("main_closed")
