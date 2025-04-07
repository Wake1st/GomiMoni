class_name VehicleController


const JOYSTICK_DEADZONE: float = 0.2

static var isActive: bool = false


static func get_movement() -> Vector2:
	if !isActive:
		return Vector2.ZERO
	
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", JOYSTICK_DEADZONE)


static func get_character_swap() -> int:
	if !isActive:
		return 0
	
	if Input.is_action_just_pressed("swap_character_next"):
		return 1
	if Input.is_action_just_pressed("swap_character_prev"):
		return -1
	return 0


static func get_menu_select() -> bool:
	if !isActive:
		return false
	
	return Input.is_action_just_pressed("select_menu")
