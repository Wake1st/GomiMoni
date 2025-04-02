extends Node3D


@onready var gomi_to_hole: Level = $GomiToHole


func _ready() -> void:
	gomi_to_hole.completed.connect(handle_level_completed)
	gomi_to_hole.run()


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		gomi_to_hole.reset()


func handle_level_completed() -> void:
	print("level complete!")
