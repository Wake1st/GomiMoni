class_name MainContainer
extends Node3D


signal main_closed
signal level_selection(number: int)

const MUSIC_FADE_DURATION: float = 0.4

@onready var levelSelector: LevelSelector = $LevelSelector
@onready var mainSelector: MainSelector = $MainSelector
@onready var settings: SettingsMenu = $Settings
@onready var credits: CreditsMenu = $Credits

@onready var cinemaGraph: CinemaGraph = $CinemaGraph
@onready var liveCamera: LiveCamera = %LiveCamera
@onready var rootCamera: Camera3D = %RootCamera

@onready var musicPlayer: MusicPlayer = $MusicPlayer
@onready var buttonSFX: AudioStreamPlayer = $ButtonSFX
@onready var cancelSFX = $CancelSFX

var atSubMenu: bool = false
var currentFocus: Node
var navigating: bool = false


func _ready():
	credits.setup(handle_cancel_selection)
	settings.setup(handle_cancel_selection)
	levelSelector.setup(handle_cancel_selection, handle_level_selected)
	mainSelector.setup(handle_main_selection)
	
	liveCamera.setup(rootCamera)
	liveCamera.transition_finished.connect(handle_transition_ended)
	cinemaGraph.transition_finished.connect(handle_cinemagraph_finished)


func open() -> void:
	# reset camera position to start of cinema-graph
	cinemaGraph.send_camera(CinemaGraph.STILLS.ROOT, true)
	
	# open animation
	liveCamera.open_transition()
	musicPlayer.fade_in(MUSIC_FADE_DURATION)
	
	# unlock new levels
	levelSelector.check_available_options()


func run() -> void:
	# enable controls
	UIController.isActive = true
	mainSelector.focusSystem.activate()
	
	# set the state
	StageState.currentState = StageState.STAGES.MAIN


func return_to_root() -> void:
	# don't send commands until at new menu
	if navigating:
		return
	else:
		navigating = true
	
	# swap focus
	currentFocus.activate(false)
	currentFocus = mainSelector.focusSystem
	
	# send camera back to start
	cinemaGraph.send_camera(CinemaGraph.STILLS.ROOT)
	
	# notify user with sound
	cancelSFX.play()


func handle_main_selection(option: MainOption.OPTIONS) -> void:
	# don't send commands until at new menu
	if navigating:
		return
	else:
		navigating = true
	
	# first, ensure we know we're away from the main menu
	atSubMenu = true
	mainSelector.focusSystem.activate(false)
	
	# next, send the camera to the sub menu
	match option:
		MainOption.OPTIONS.LEVELS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.SELECTION)
			currentFocus = levelSelector.focusSystem
		MainOption.OPTIONS.SETTINGS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.SETTINGS)
			currentFocus = settings.focusSystem
		MainOption.OPTIONS.CREDITS:
			cinemaGraph.send_camera(CinemaGraph.STILLS.CREDITS)
			currentFocus = credits.focusSystem
		MainOption.OPTIONS.EXIT:
			get_tree().quit()
	
	# play the button sfx
	buttonSFX.play()


func handle_cancel_selection() -> void:
	return_to_root()


func handle_level_selected(number: int) -> void:
	# animate camera through tube
	liveCamera.close_transition()
	musicPlayer.fade_out(MUSIC_FADE_DURATION)
	
	# turn off the ui controls
	UIController.isActive = false
	currentFocus.activate(false)
	
	# notify staging system for level loading
	emit_signal("level_selection", number)
	
	# play the button sfx
	buttonSFX.play()


func handle_cinemagraph_finished() -> void:
	# activate the menu we arrive at
	currentFocus.activate()
	navigating = false


func handle_transition_ended(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("main_closed")
