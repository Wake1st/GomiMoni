class_name LevelContainer
extends Node3D


signal level_closed
signal main_selected

@onready var camera: LevelCamera = $LevelCamera

var highestLevelFinished: int = 0


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)


func open() -> void:
	camera.open_transition()

func run(levelNumber: int = -1) -> void:
	print("running: %s" % levelNumber)
	
	# if no number is given, play the next level
	if levelNumber < 0:
		print("setup highest level: ", highestLevelFinished + 1)
	else:
		print("setup given level: ", levelNumber)


func leave() -> void:
	print("leaving level...")
	camera.close_transition()


func swap() -> void:
	print("swapping levels...")
	
	# despawn the current level
	
	# increment level number
	highestLevelFinished += 1
	
	# setup the next level


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("level_closed")
