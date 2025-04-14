class_name LevelContainer
extends Node3D


signal level_ready
signal level_closed(passed: bool)

const MUSIC_FADE_DURATION: float = 1.0

@onready var camera: LevelCamera = $LevelCamera

@onready var pauseSelector: PauseSelector = $PauseSelector
@onready var instructions: Instructions = $Instructions
@onready var vehicleUI: VehicleUI = $VehicleUI

@onready var musicPlayer: MusicPlayer = $MusicPlayer
@onready var buttonSFX: AudioStreamPlayer = $ButtonSFX
@onready var enterSFX: AudioStreamPlayer = $EnterSFX
@onready var exitSFX: AudioStreamPlayer = $ExitSFX

var level: Level
var hasPassedLevel: bool = false


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)
	pauseSelector.setup(handle_pause_selection)


func setup(levelNumber: int = -1) -> void:
	# if no number is given, it plays the next level
	var scene: PackedScene = LevelList.get_level(levelNumber)
	
	# setup the level
	level = scene.instantiate()
	add_child(level)
	level.setup(handle_vehicle_activation)
	level.completed.connect(success)
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
	# let user play
	level.run()
	
	# set the state
	StageState.currentState = StageState.STAGES.LEVEL
	
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


func success(moni: float) -> void:
	# marked for success
	hasPassedLevel = true
	
	# increment level number
	LevelList.increment_level()
	
	# give the player moni
	TrashData.moni += moni
	
	# leave level
	exit()


func teardown() -> void:
	level.completed.disconnect(success)
	remove_child(level)
	level.queue_free()


func swap() -> void:
	# despawn the current level
	teardown()
	
	# setup the next level
	setup()


func handle_vehicle_activation(vehicle: Vehicle.VEHICLE_TYPE) -> void:
	vehicleUI.display(vehicle)


func handle_pause_selection(option: PauseOption.OPTIONS) -> void:
	# regardless of what we choose, we must close the menu
	pauseSelector.toggle_menu()
	instructions.toggle_menu()
	
	# choose what to do based on the selected option
	match option:
		PauseOption.OPTIONS.RETURN:
			# play sfx?
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
