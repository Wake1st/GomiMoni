extends Node3D


@onready var cover: Cover = $Cover
@onready var spawner: Spawner = $Spawner


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if cover.isOpened:
			cover.close()
		else:
			cover.open()
	
	if Input.is_key_pressed(KEY_S):
		spawner.spawn()
