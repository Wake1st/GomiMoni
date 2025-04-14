extends Node3D


@export_range(0,5) var testingLevel: int

@onready var levelContainer: LevelContainer = $LevelContainer


func _ready():
	levelContainer.level_ready.connect(handle_level_ready)
	levelContainer.level_closed.connect(handle_level_closed)
	levelContainer.setup(testingLevel)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		levelContainer.level.reset()


func handle_level_ready() -> void:
	levelContainer.open()


func handle_level_closed() -> void:
	levelContainer.teardown()
	levelContainer.setup(testingLevel)
