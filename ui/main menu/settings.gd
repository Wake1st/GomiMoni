class_name SettingsMenu
extends Node3D


const SAMPLE_COOLDOWN: float = 0.6

@onready var cancelOption: CancelOption = $CancelOption
@onready var masterSlider: Slider3D = $MasterSlider
@onready var musicSlider: Slider3D = $MusicSlider

@onready var focusSystem: SettingsFocusSystem = $SettingsFocusSystem
@onready var sfxSlider: Slider3D = $SFXSlider
@onready var sfxSample: AudioStreamPlayer = $SFXSample
@onready var sampleTimer: Timer = $SampleTimer


func setup(cancelCallback: Callable) -> void:
	# connect cancel callback
	cancelOption.selected.connect(cancelCallback)
	cancelOption.setup()
	
	# connect audio settings
	masterSlider.value_changed.connect(handle_master_changed)
	musicSlider.value_changed.connect(handle_music_changed)
	sfxSlider.value_changed.connect(handle_sfx_changed)
	
	# set initial values
	AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index("Master"), 
		masterSlider.initialValue
	)
	AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index("Music"), 
		musicSlider.initialValue
	)
	AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index("SFX"), 
		sfxSlider.initialValue
	)


func handle_master_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func handle_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func handle_sfx_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
	
	# play a sample to help the user
	if sampleTimer.is_stopped():
		sfxSample.play()
		sampleTimer.start(SAMPLE_COOLDOWN)


func _on_sample_timer_timeout() -> void:
	sampleTimer.stop()
