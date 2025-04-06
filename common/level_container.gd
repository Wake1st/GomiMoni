class_name LevelContainer
extends Node3D


signal level_ready
signal level_closed

@onready var camera: LevelCamera = $LevelCamera

var level: Level


func _ready() -> void:
	camera.transition_finished.connect(handle_camera_transition_finished)


func setup(levelNumber: int = -1) -> void:
	# if no number is given, it plays the next level
	var scene: PackedScene = LevelList.get_level(levelNumber)
	level = scene.instantiate()
	add_child(level)
	level.completed.connect(leave)
	emit_signal("level_ready")


func open() -> void:
	camera.open_transition()


func run() -> void:
	level.run()


func leave() -> void:
	# increment level number
	LevelList.increment_level()
	
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
