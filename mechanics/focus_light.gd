class_name FocusLight
extends SpotLight3D


signal transition_finished

enum MODE {
	FOCUSED,
	OPENED,
}

const FOCUS_ANGLE: float = 8.0
const OPEN_ANGLE: float = 36.0
const FOCUS_ANGLE_ATTENUATION: float = 0.2
const OPEN_ANGLE_ATTENUATION: float = 2.0
const TWEEN_DURATION: float = 0.8

var tween: Tween


func _ready() -> void:
	reset()


func reset() -> void:
	turn_on(false)
	set_mode(MODE.FOCUSED)


func turn_on(value: bool = true) -> void:
	if value:
		light_energy = 1.0
	else:
		light_energy = 0.0


func set_mode(m: MODE) -> void:
	# set directly according to mode
	match m:
		MODE.FOCUSED:
			spot_angle = FOCUS_ANGLE
			spot_angle_attenuation = FOCUS_ANGLE_ATTENUATION
		MODE.OPENED:
			spot_angle = OPEN_ANGLE
			spot_angle_attenuation = OPEN_ANGLE_ATTENUATION


func to_mode(m: MODE) -> void:
	# get the target settings
	var angle
	var angle_attenuation
	match m:
		MODE.FOCUSED:
			angle = FOCUS_ANGLE
			angle_attenuation = FOCUS_ANGLE_ATTENUATION
		MODE.OPENED:
			angle = OPEN_ANGLE
			angle_attenuation = OPEN_ANGLE_ATTENUATION
	
	# transition between modes
	tween = create_tween()
	tween.tween_property(self, "spot_angle", angle, TWEEN_DURATION)
	tween.parallel()
	tween.tween_property(self, "spot_angle_attenuation", angle_attenuation, TWEEN_DURATION)
	tween.tween_callback(handle_tween_finished)


func handle_tween_finished() -> void:
	emit_signal("transition_finished")
