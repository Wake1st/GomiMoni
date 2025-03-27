class_name UIController


enum SELECTION {
	NONE,
	ACCEPT,
	CANCEL,
}

const UI_DEADZONE: float = 0.55


static func get_direction() -> Vector2:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up", UI_DEADZONE)
	return direction.round()


static func get_selection() -> SELECTION:
	if Input.is_action_just_pressed("ui_accept"):
		return SELECTION.ACCEPT
	elif Input.is_action_just_pressed("ui_cancel"):
		return SELECTION.CANCEL
	else:
		return SELECTION.NONE
