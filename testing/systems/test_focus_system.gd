extends Node3D


@onready var focusSystem: FocusSystem = $FocusSystem


func _ready() -> void:
	focusSystem.all_open.connect(handle_all_open)


func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if focusSystem.allOn:
			focusSystem.reset()
		else:
			focusSystem.run()


func handle_all_open() -> void:
	print("all open!")
