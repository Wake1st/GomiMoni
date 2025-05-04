class_name Main
extends Node3D


@onready var titleScreen: TitleScreen = $TitleScreen
@onready var stagingSystem: StagingSystem = $StagingSystem


func _ready():
	# load any save data
	TrashData.load()
	
	# setup title
	titleScreen.finished.connect(handle_title_finished)
	titleScreen.run()


func handle_title_finished() -> void:
	# we don't need to see the title
	titleScreen.visible = false
	
	# this is where the fun begins
	stagingSystem.setup()
