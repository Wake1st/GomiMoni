class_name VoiceBox
extends AudioStreamPlayer


const PITCH_VARIANCE: float = 0.4


func run(word: VoiceList.WORD) -> void:
	stream = VoiceList.get_voice(word)
	pitch_scale = 1 + randf_range(-PITCH_VARIANCE, PITCH_VARIANCE)
	play()
