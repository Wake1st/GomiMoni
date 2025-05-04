class_name TitleScreen
extends Node3D


enum STAGE {
	PRE,
	GOMI,
	MID,
	MONI,
	POST
}

signal finished

const CLOSED_ANGLE: float = 0.0
const OPEN_ANGLE: float = 32.0
const TWEEN_DURATION: float = 0.6

const PRE_TIME: float = 0.4
const MID_TIME: float = 0.4
const POST_TIME: float = 0.6

@onready var camera: Camera3D = $Camera3D
@onready var light: SpotLight3D = $SpotLight3D
@onready var voiceBox: VoiceBox = $VoiceBox
@onready var timer: Timer = $Timer

var tween: Tween
var stage: STAGE


func _ready() -> void:
	stage = STAGE.PRE
	light.spot_angle = CLOSED_ANGLE
	camera.current = true


func run() -> void:
	open()


func open() -> void:
	# open the spotlight
	tween = create_tween()
	tween.tween_property(light, "spot_angle", OPEN_ANGLE, TWEEN_DURATION)
	
	# short delay for the timer
	timer.start(PRE_TIME)


func close() -> void:
	# open the spotlight
	tween = create_tween()
	tween.tween_property(light, "spot_angle", CLOSED_ANGLE, TWEEN_DURATION)
	tween.tween_callback(handle_closed)


func _on_timer_timeout():
	match stage:
		STAGE.PRE:
			stage = STAGE.GOMI
			voiceBox.run(VoiceList.WORD.GOMI)
		STAGE.MID:
			stage = STAGE.MONI
			voiceBox.run(VoiceList.WORD.MONI)
		STAGE.POST:
			close()


func _on_voice_box_finished():
	match stage:
		STAGE.GOMI:
			stage = STAGE.MID
			timer.start(MID_TIME)
		STAGE.MONI:
			stage = STAGE.POST
			timer.start(POST_TIME)


func handle_closed() -> void:
	emit_signal("finished")
