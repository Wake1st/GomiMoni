class_name FocusLight
extends SpotLight3D


signal transition_finished

enum MODE {
	FOCUSED,
	OPENED,
}

@export var focusAngle: float = 8.0
@export var openAngle: float = 36.0
@export var focusAngleAttenuation: float = 0.2
@export var openAngleAttenuation: float = 2.0
@export var openDuration: float = 0.8

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
			spot_angle = focusAngle
			spot_angle_attenuation = focusAngleAttenuation
		MODE.OPENED:
			spot_angle = openAngle
			spot_angle_attenuation = openAngleAttenuation


func to_mode(m: MODE) -> void:
	# get the target settings
	var angle
	var angle_attenuation
	match m:
		MODE.FOCUSED:
			angle = focusAngle
			angle_attenuation = focusAngleAttenuation
		MODE.OPENED:
			angle = openAngle
			angle_attenuation = openAngleAttenuation
	
	# transition between modes
	tween = create_tween()
	tween.tween_property(self, "spot_angle", angle, openDuration)
	tween.parallel()
	tween.tween_property(self, "spot_angle_attenuation", angle_attenuation, openDuration)
	tween.tween_callback(handle_tween_finished)


func handle_tween_finished() -> void:
	emit_signal("transition_finished")
