class_name LightingSystem
extends Node


signal all_open

@export var pulseTime: float = 0.4
@export var focusTime: float = 0.6
@export var lights: Array[FocusLight] = []

@onready var timer: Timer = $Timer

var lightIndex: int = 0
var lightsWide: int = 0
var allOn: bool = false


func _ready() -> void:
	for light in lights:
		light.transition_finished.connect(handle_light_transition_finished)


func run() -> void:
	if !allOn:
		timer.start(pulseTime)


func reset() -> void:
	# reset all lights
	for light in lights:
		light.reset()
	
	# reset values
	allOn = false
	lightIndex = 0
	lightsWide = 0


func _on_timer_timeout():
	if allOn:
		# ensure no more loops
		timer.stop()
		
		# open up all the lights
		for light in lights:
			light.to_mode(FocusLight.MODE.OPENED)
	else:
		# turn on the current light
		lights[lightIndex].turn_on()
		lightIndex += 1
		
		# if all on, wait for focus
		if lightIndex == lights.size():
			allOn = true
			timer.stop()
			timer.start(focusTime)


func handle_light_transition_finished() -> void:
	# check if all lights are on
	lightsWide += 1
	allOn = lightsWide == lights.size()
	
	# notify listeners
	if allOn:
		emit_signal("all_open")
