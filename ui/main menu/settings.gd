class_name SettingsMenu
extends Node3D


@onready var cancelOption: CancelOption = $CancelOption
@onready var masterSlider: Slider3D = $MasterSlider
@onready var musicSlider: Slider3D = $MusicSlider
@onready var sfxSlider: Slider3D = $SFXSlider
@onready var sfxExample: AudioStreamPlayer = $SFXExample


func setup(cancelCallback: Callable) -> void:
	# connect cancel callback
	cancelOption.selected.connect(cancelCallback)


func handle_master_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func handle_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func handle_sfx_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
	
	# play a sample to help the user
	sfxExample.play()
