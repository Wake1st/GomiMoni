extends Node3D


@onready var gomi_spawner = $GomiSpawner
@onready var flyer_spawner = $FlyerSpawner
@onready var heavy_spawner = $HeavySpawner


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		gomi_spawner.spawn()
		flyer_spawner.spawn()
		heavy_spawner.spawn()
