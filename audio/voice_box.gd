class_name VoiceBox
extends AudioStreamPlayer


func run(word: VoiceList.WORD) -> void:
	stream = VoiceList.get_voice(word)
	play()
