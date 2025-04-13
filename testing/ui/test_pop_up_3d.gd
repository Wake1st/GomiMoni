extends Node3D


@export var popUpTime: float = 2.0

@onready var pop_up_3d = $PopUp3D

var isOpen: bool = false


func _input(_event):
	# test static display
	if Input.is_key_label_pressed(KEY_S):
		if isOpen:
			pop_up_3d.off()
		else:
			pop_up_3d.on()
		
		# toggle open
		isOpen = !isOpen
	
	# test dynamic display
	if Input.is_key_label_pressed(KEY_D):
		if !isOpen:
			pop_up_3d.on(popUpTime)
