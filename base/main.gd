class_name Main
extends Node3D


@onready var titleScreen: TitleScreen = $TitleScreen
@onready var stagingSystem: StagingSystem = $StagingSystem


func _ready():
	titleScreen.finished.connect(handle_title_finished)
	titleScreen.run()


func handle_title_finished() -> void:
	titleScreen.visible = false
	stagingSystem.setup()
