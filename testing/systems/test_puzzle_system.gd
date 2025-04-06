extends Node3D


@onready var puzzle_system: PuzzleSystem = $PuzzleSystem
@onready var cover: Cover = $Cover
@onready var basket: Basket = $Basket
@onready var switch: Switch = $Switch

var isOn: bool = false


func _input(_event):
	# trigger switch
	if Input.is_key_pressed(KEY_1):
		if !isOn:
			switch.throw()
			isOn = true
	
	# trigger basket
	if Input.is_key_pressed(KEY_2):
		basket.toggleOn()
	
	# reset
	if Input.is_action_just_pressed("ui_accept"):
		switch.reset()
		isOn = false
		basket.reset()
		cover.lock()
