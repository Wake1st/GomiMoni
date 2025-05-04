extends Node3D


@onready var focusLight: FocusLight = $FocusLight

var isOn: bool = false


func _ready() -> void:
	focusLight.transition_finished.connect(handle_transition_finished)


func _input(_event) -> void:
	var fPressed = Input.is_key_label_pressed(KEY_F)
	var oPressed = Input.is_key_label_pressed(KEY_O)
	var shiftPressed = Input.is_key_label_pressed(KEY_SHIFT)
	var acceptPressed = Input.is_action_just_pressed("ui_accept")
	
	if shiftPressed && fPressed:
		focusLight.set_mode(FocusLight.MODE.FOCUSED)
	elif shiftPressed && oPressed:
		focusLight.set_mode(FocusLight.MODE.OPENED)
	elif fPressed:
		focusLight.to_mode(FocusLight.MODE.FOCUSED)
	elif oPressed:
		focusLight.to_mode(FocusLight.MODE.OPENED)
	elif acceptPressed:
		isOn = !isOn
		focusLight.turn_on(isOn)


func handle_transition_finished() -> void:
	print("light open!")
