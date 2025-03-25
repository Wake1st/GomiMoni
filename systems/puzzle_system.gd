class_name PuzzleSystem
extends Node


@export var lock: Lock
@export var keys: Array[Key]


func _ready():
	for key in keys:
		key.triggered.connect(check_keys)


## Will unlock the lock when all keys are true
func check_keys() -> void:
	for key in keys:
		if key.check() == false:
			return
	
	lock.unlock()
