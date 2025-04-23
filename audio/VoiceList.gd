class_name VoiceList


enum WORD {
	GOMI,
	MONI
}

const VOICES: int = 16

static var gomis: Dictionary = {
	0 : preload("res://assets/sfx/voice/gomi - tim.wav"),
	1 : preload("res://assets/sfx/voice/gomi - clown.wav"),
	2 : preload("res://assets/sfx/voice/gomi - detective.wav"),
	3 : preload("res://assets/sfx/voice/gomi - evil.wav"),
	4 : preload("res://assets/sfx/voice/gomi - fancy.wav"),
	5 : preload("res://assets/sfx/voice/gomi - goblin.wav"),
	6 : preload("res://assets/sfx/voice/gomi - greed.wav"),
	7 : preload("res://assets/sfx/voice/gomi - hill.wav"),
	8 : preload("res://assets/sfx/voice/gomi - mouse.wav"),
	9 : preload("res://assets/sfx/voice/gomi - old.wav"),
	10 : preload("res://assets/sfx/voice/gomi - radical.wav"),
	11 : preload("res://assets/sfx/voice/gomi - robo.wav"),
	12 : preload("res://assets/sfx/voice/gomi - singing.wav"),
	13 : preload("res://assets/sfx/voice/gomi - skeleton.wav"),
	14 : preload("res://assets/sfx/voice/gomi - smug.wav"),
	15 : preload("res://assets/sfx/voice/gomi - snake.wav"),
}

static var monis: Dictionary = {
	0 : preload("res://assets/sfx/voice/moni - tim.wav"),
	1 : preload("res://assets/sfx/voice/moni - clown.wav"),
	2 : preload("res://assets/sfx/voice/moni - detective.wav"),
	3 : preload("res://assets/sfx/voice/moni - evil.wav"),
	4 : preload("res://assets/sfx/voice/moni - fancy.wav"),
	5 : preload("res://assets/sfx/voice/moni - goblin.wav"),
	6 : preload("res://assets/sfx/voice/moni - greed.wav"),
	7 : preload("res://assets/sfx/voice/moni - hill.wav"),
	8 : preload("res://assets/sfx/voice/moni - mouse.wav"),
	9 : preload("res://assets/sfx/voice/moni - old.wav"),
	10 : preload("res://assets/sfx/voice/moni - radical.wav"),
	11 : preload("res://assets/sfx/voice/moni - robo.wav"),
	12 : preload("res://assets/sfx/voice/moni - singing.wav"),
	13 : preload("res://assets/sfx/voice/moni - skeleton.wav"),
	14 : preload("res://assets/sfx/voice/moni - smug.wav"),
	15 : preload("res://assets/sfx/voice/moni - snake.wav"),
}



static func get_voice(word: WORD) -> AudioStreamWAV:
	# generate random
	var index = randi() % VOICES
	
	# get the specific word and voice
	var stream: AudioStreamWAV
	match word:
		WORD.GOMI:
			stream = gomis[index] as AudioStreamWAV
		WORD.MONI:
			stream = monis[index] as AudioStreamWAV
	
	return stream
