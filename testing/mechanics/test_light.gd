extends Node3D


@onready var light = $Light


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		light.toggle()
