class_name MusicPlayer
extends AudioStreamPlayer


const MUSIC_OFF: float = -40
const MUSIC_ON: float = 0.0

@export var songs: Array[AudioStreamMP3] = []

var currentIndex: int
var tween: Tween


func fade_in(duration: float) -> void:
	# ensure our volume is practically off
	volume_db = MUSIC_OFF
	
	# turn up the music
	tween = create_tween()
	tween.tween_property(self, "volume_db", MUSIC_ON, duration)
	tween.set_ease(Tween.EASE_OUT)
	
	# start up the music
	play_song()


func fade_out(duration: float) -> void:
	# turn down the music, and stop when practically off
	tween = create_tween()
	tween.tween_property(self, "volume_db", MUSIC_OFF, duration)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_callback(_on_fade_out_finished)


func _on_fade_out_finished() -> void:
	# ensure no music plays
	stop()
	
	# swap songs for variety
	iterate_index()


func _on_finished():
	iterate_index()
	play_song()


func iterate_index() -> void:
	currentIndex += 1
	if currentIndex == songs.size():
		currentIndex = 0


func play_song() -> void:
	stream = songs[currentIndex]
	play()
