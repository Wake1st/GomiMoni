class_name LevelContainer
extends Node3D


signal level_ready
signal level_closed(passed: bool)

@onready var camera: LevelCamera = $LevelCamera
@onready var pauseSelector: PauseSelector = $PauseSelector
@onready var instructions: Instructions = $Instructions

var level: Level
var passedLevel: bool = false


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)
	pauseSelector.setup(handle_pause_selection)


func setup(levelNumber: int = -1) -> void:
	# if no number is given, it plays the next level
	var scene: PackedScene = LevelList.get_level(levelNumber)
	
	# setup the level
	level = scene.instantiate()
	add_child(level)
	level.completed.connect(success)
	camera.opened_size = level.cameraSize
	
	# the level is ready to play
	emit_signal("level_ready")


func open() -> void:
	camera.open_transition()


func run() -> void:
	level.run()


func exit() -> void:
	# marked for failure
	passedLevel = false
	
	# start the goodbye
	camera.close_transition()


func success() -> void:
	# marked for success
	passedLevel = true
	
	# increment level number
	LevelList.increment_level()
	
	# start the goodbye
	camera.close_transition()


func teardown() -> void:
	level.completed.disconnect(success)
	remove_child(level)
	level.queue_free()


func swap() -> void:
	# despawn the current level
	teardown()
	
	# setup the next level
	setup()


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


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("level_closed", passedLevel)
