class_name LevelContainer
extends Node3D


signal level_closed
signal main_selected

@onready var camera: LevelCamera = $LevelCamera

var level: Level
var highestLevelFinished: int = 0


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)


func setup(levelNumber: int = -1) -> void:
	# if no number is given, play the next level
	if levelNumber < 0:
		levelNumber = highestLevelFinished + 1
	
	var scene: PackedScene = LevelList.items[levelNumber]
	level = scene.instantiate()
	add_child(level)
	level.completed.connect(leave)


func open() -> void:
	camera.open_transition()


func run(levelNumber: int = -1) -> void:
	level.run()


func leave() -> void:
	# increment level number
	highestLevelFinished += 1
	
	# start the goodbye
	camera.close_transition()


func teardown() -> void:
	level.completed.disconnect(leave)
	remove_child(level)
	level = null


func swap() -> void:
	# despawn the current level
	teardown()
	
	# setup the next level
	setup()


func handle_camera_transition_finished(isOpen: bool) -> void:
	if isOpen:
		run()
	else:
		emit_signal("level_closed")
