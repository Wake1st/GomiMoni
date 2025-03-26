extends Node3D


@onready var levelScene: PackedScene = preload("res://mechanics/goal.tscn")
@onready var staging_system: StagingSystem = $StagingSystem

var activeLevel
var nextLevel


func _ready():
	activeLevel = levelScene.instantiate()
	nextLevel = levelScene.instantiate()
	staging_system.setup(activeLevel)
	staging_system.transition_finished.connect(handle_transition_finished)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		staging_system.transition(nextLevel)


func handle_transition_finished(oldLevel: Node3D) -> void:
	print("Transition finished!")
	
	oldLevel.queue_free()
	
	activeLevel = nextLevel
	nextLevel = levelScene.instantiate()
