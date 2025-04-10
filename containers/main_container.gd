class_name MainContainer
extends Node3D


signal main_closed
signal level_selection(number: int)

@onready var levelSelector: LevelSelector = $LevelSelector
@onready var mainSelector: MainSelector = $MainSelector
@onready var cinemaGraph: CinemaGraph = $CinemaGraph
@onready var liveCamera: LiveCamera = %LiveCamera
@onready var rootCamera: Camera3D = %RootCamera

var atSubMenu: bool = false


func _ready():
	levelSelector.setup(handle_level_selected)
	mainSelector.setup(handle_main_selection)
	liveCamera.setup(rootCamera)
	liveCamera.transition_finished.connect(handle_transition_ended)


func _input(_event: InputEvent) -> void:
	if atSubMenu && Input.is_action_just_pressed("ui_cancel"):
		cinemaGraph.send_camera(CinemaGraph.STILLS.ROOT)


func open() -> void:
	# reset camera position to start of cinema-graph
	cinemaGraph.send_camera(CinemaGraph.STILLS.ROOT, true)
	
	# open animation
	liveCamera.open_transition()
	
	# unlock new levels
	levelSelector.check_available_options()


func run() -> void:
	# enable controls
	UIController.isActive = true
	
	# set the state
	StageState.currentState = StageState.STAGES.MAIN


func handle_main_selection(option: MainOption.OPTIONS) -> void:
	# first, ensure we know we're away from the main menu
	atSubMenu = true

	# next, send the camera to the sub menu
	match option:
		MainOption.OPTIONS.LEVELS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.SELECTION)
		MainOption.OPTIONS.SETTINGS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.SETTINGS)
		MainOption.OPTIONS.CREDITS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.CREDITS)


func handle_level_selected(number: int) -> void:
	# animate camera through tube
	liveCamera.close_transition()
	
	# turn off the ui controls
	UIController.isActive = false
	
	# notify staging system for level loading
	emit_signal("level_selection", number)


func handle_transition_ended(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("main_closed")
