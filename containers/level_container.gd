class_name LevelContainer
extends Node3D


signal level_ready
signal level_closed(passed: bool)

const MUSIC_FADE_DURATION: float = 1.0

@onready var camera: LevelCamera = $LevelCamera

@onready var pauseSelector: PauseSelector = $PauseSelector
@onready var instructions: Instructions = $Instructions
@onready var vehicleUI: VehicleUI = $VehicleUI
@onready var focusSystem: FocusSystem = $FocusSystem

@onready var musicPlayer: MusicPlayer = $MusicPlayer
@onready var buttonSFX: AudioStreamPlayer = $ButtonSFX
@onready var enterSFX: AudioStreamPlayer = $EnterSFX
@onready var exitSFX: AudioStreamPlayer = $ExitSFX
@onready var voiceBox: VoiceBox = $VoiceBox

var level: Level
var hasPassedLevel: bool = false
var menuOpened: bool = false


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)
	pauseSelector.setup(focusSystem.focus_on, handle_pause_selection)
	focusSystem.cancel_selected.connect(handle_menu_exit)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		toggle_menu()


func setup(levelNumber) -> void:
	# if no number is given, it plays the next level
	var scene: PackedScene = LevelList.get_level(levelNumber)
	
	# setup the level
	level = scene.instantiate()
	add_child(level)
	level.setup(handle_vehicle_activation)
	level.completed.connect(success)
	level.active.connect(handle_level_active)
	camera.opened_size = level.cameraSize
	
	# the level is ready to play
	emit_signal("level_ready")


func open() -> void:
	# reset passing check
	hasPassedLevel = false
	
	# say hello
	camera.open_transition()
	musicPlayer.fade_in(MUSIC_FADE_DURATION)
	enterSFX.play()


func run() -> void:
	# enable ui navigation
	focusSystem.activate()
	
	# set the state
	StageState.currentState = StageState.STAGES.LEVEL
	
	# let user play
	level.run()
	
	# let user know about the instructions for specific levels
	if LevelList.current_level_index() == 0:
		instructions.popup_instruction(Instructions.POPUP.MOVEMENT)
	elif LevelList.current_level_index() == 2:
		instructions.popup_instruction(Instructions.POPUP.SWAPPING)


func exit() -> void:
	# start the goodbye
	camera.close_transition()
	musicPlayer.fade_out(MUSIC_FADE_DURATION)
	exitSFX.play()
	
	# ensure the levels are inactive
	focusSystem.activate(false)


func success(moni: float) -> void:
	# marked for success
	hasPassedLevel = true
	
	# increment level number
	LevelList.increment_level()
	
	# give the player moni
	TrashData.moni += moni
	
	# congratulate the player
	voiceBox.run(VoiceList.WORD.MONI)
	
	# leave level
	exit()


func teardown() -> void:
	level.completed.disconnect(success)
	level.active.disconnect(handle_level_active)
	remove_child(level)
	level.queue_free()


func swap() -> void:
	# despawn the current level
	teardown()
	
	# setup the next level
	setup(LevelList.current_level_index())


func handle_level_active() -> void:
	voiceBox.run(VoiceList.WORD.GOMI)


func handle_vehicle_activation(vehicle: Vehicle.VEHICLE_TYPE) -> void:
	vehicleUI.display(vehicle)


func toggle_menu() -> void:
	menuOpened = !menuOpened
	pauseSelector.toggle_menu(menuOpened)
	instructions.toggle_menu(menuOpened)
	focusSystem.activate(menuOpened)


func handle_menu_exit() -> void:
	# exit the menu
	pauseSelector.toggle_menu(false)
	instructions.toggle_menu(false)
	
	# disable ui navigation
	focusSystem.activate(false)
	
	# update state
	menuOpened = false


func handle_pause_selection(option: PauseOption.OPTIONS) -> void:
	# only run if active
	if !focusSystem.isActive:
		return
	
	# regardless of what we choose, we must close the menu
	handle_menu_exit()
	
	# choose what to do based on the selected option
	match option:
		PauseOption.OPTIONS.RETURN:
			# simply return
			pass
		PauseOption.OPTIONS.RESET:
			level.reset()
		PauseOption.OPTIONS.LEAVE:
			# leave the area
			exit()
	
	# play the button sfx
	buttonSFX.play()


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("level_closed", hasPassedLevel)
