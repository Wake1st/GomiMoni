class_name VehicleController


const JOYSTICK_DEADZONE: float = 0.2


static func get_movement() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", JOYSTICK_DEADZONE)


static func get_character_swap() -> int:
	if Input.is_action_just_pressed("swap_character_next"):
		return 1
	if Input.is_action_just_pressed("swap_character_prev"):
		return -1
	return 0


static func get_menu_select() -> bool:
	return Input.is_action_just_pressed("select_menu")
